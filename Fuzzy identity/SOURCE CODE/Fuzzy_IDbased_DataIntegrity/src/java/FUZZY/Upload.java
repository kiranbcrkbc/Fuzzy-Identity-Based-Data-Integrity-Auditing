  /*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package FUZZY;

import com.oreilly.servlet.MultipartRequest;
import java.util.Base64;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author java3
 */
public class Upload extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    File file;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Connection con = null;
        PreparedStatement ps = null;
        try {
            String uploadPath = null;
            try {
                uploadPath = request.getServletContext().getRealPath("/uploads");
            } catch (Exception ex) {
                // Fallback if servlet context is not available
            }
            if (uploadPath == null || uploadPath.trim().isEmpty()) {
                uploadPath = System.getProperty("user.dir") + File.separator + "uploads";
            }
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            String filepath = uploadDir.getAbsolutePath() + File.separator;

            MultipartRequest m = new MultipartRequest(request, filepath, 50 * 1024 * 1024);
            String fname = m.getParameter("fname");
            File file = m.getFile("data");
            if (file == null) {
                response.sendRedirect("File_Upload.jsp?failed");
                return;
            }

            HttpSession user = request.getSession(false);
            if (user == null || user.getAttribute("uname") == null || user.getAttribute("uid") == null) {
                response.sendRedirect("User.jsp?Msg=Session_Expired");
                return;
            }
            String uname = user.getAttribute("uname").toString();
            String uid = user.getAttribute("uid").toString();

            // Read file content with UTF-8 support and fallback
            StringBuilder sb = new StringBuilder();
            BufferedReader br = null;
            try {
                br = new BufferedReader(new java.io.InputStreamReader(new java.io.FileInputStream(file), "UTF-8"));
                String temp;
                boolean firstLine = true;
                while ((temp = br.readLine()) != null) {
                    if (!firstLine) sb.append("\n");
                    sb.append(temp);
                    firstLine = false;
                }
            } catch (Exception readEx) {
                byte[] rawBytes = java.nio.file.Files.readAllBytes(file.toPath());
                sb = new StringBuilder(Base64.getEncoder().encodeToString(rawBytes));
            } finally {
                if (br != null) try { br.close(); } catch (Exception ignored) {}
            }

            KeyGenerator Attrib_key = KeyGenerator.getInstance("AES");
            Attrib_key.init(128);
            SecretKey secretKey = Attrib_key.generateKey();

            Encryption e = new Encryption();
            String encryptedtext = e.encrypt(sb.toString(), secretKey);
            if (encryptedtext == null) {
                encryptedtext = "";
            }

            // Storing encrypted file safely
            FileWriter fw = null;
            try {
                fw = new FileWriter(file);
                fw.write(encryptedtext);
            } finally {
                if (fw != null) try { fw.close(); } catch (Exception ignored) {}
            }

            int hash1 = encryptedtext.hashCode();
            byte[] b = secretKey.getEncoded();
            String Dkey = Base64.getEncoder().encodeToString(b);

            DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            Date date = new Date();
            String time = dateFormat.format(date);

            // Optional remote FTP backup (does not block or fail local upload)
            try {
                new FTPcon().upload(file);
            } catch (Exception ftpEx) {
                System.out.println("FTP backup skipped: " + ftpEx.getMessage());
            }

            Random RANDOM = new SecureRandom();
            int PASSWORD_LENGTH = 7;
            String letters = "0123456789";
            StringBuilder fileid = new StringBuilder();
            for (int i = 0; i < PASSWORD_LENGTH; i++) {
                int index = (int) (RANDOM.nextDouble() * letters.length());
                fileid.append(letters.charAt(index));
            }
            String filekey = "file" + fileid.toString();

            con = SQLconnection.getconnection();
            if (con == null) {
                response.sendRedirect("File_Upload.jsp?failed=db_error");
                return;
            }

            String insertSql = "insert into fileupload(filename, content, user, time, dkey, conn, hashcode, uid, fname, filekey, audit_status) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(insertSql);
            ps.setString(1, file.getName());
            ps.setString(2, encryptedtext);
            ps.setString(3, uname);
            ps.setString(4, time);
            ps.setString(5, Dkey);
            ps.setString(6, sb.toString());
            ps.setString(7, String.valueOf(hash1));
            ps.setString(8, uid);
            ps.setString(9, (fname != null && !fname.trim().isEmpty()) ? fname : file.getName());
            ps.setString(10, filekey);
            ps.setString(11, "Not Audited Yet");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("File_Upload.jsp?Successful");
            } else {
                response.sendRedirect("File_Upload.jsp?failed");
            }
        } catch (Exception ex) {
            System.err.println("Upload processing error: " + ex.getMessage());
            ex.printStackTrace();
            response.sendRedirect("File_Upload.jsp?failed");
        } finally {
            SQLconnection.close(con, ps);
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
