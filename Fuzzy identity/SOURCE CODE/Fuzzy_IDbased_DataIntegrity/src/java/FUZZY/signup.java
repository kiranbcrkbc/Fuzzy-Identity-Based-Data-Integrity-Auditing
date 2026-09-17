/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package FUZZY;

import java.awt.Image;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;
import javax.imageio.ImageIO;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author java1
 */
@MultipartConfig(maxFileSize = 16177215)
public class signup extends HttpServlet {

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(true);

        String name = request.getParameter("name");
        String mail = request.getParameter("email");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String city = request.getParameter("city");
        String country = request.getParameter("country");
        String pass = request.getParameter("password");
        String rpass = request.getParameter("rpassword");

        if (name == null || name.trim().isEmpty() || mail == null || mail.trim().isEmpty() ||
            pass == null || pass.trim().isEmpty()) {
            response.sendRedirect("User_reg.jsp?failed=missing_fields");
            return;
        }

        if (rpass != null && !pass.equals(rpass)) {
            response.sendRedirect("User_reg.jsp?failed=password_mismatch");
            return;
        }

        String kgc = "waiting";
        String otp = "waiting";
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        Date date = new Date();
        String time = dateFormat.format(date);

        InputStream inputStream = null;
        String val = "0";
        try {
            Part filePart = request.getPart("bio_sign");
            if (filePart != null && filePart.getSize() > 0) {
                val = String.valueOf(filePart.getSize());
                inputStream = filePart.getInputStream();
            }
        } catch (Exception partEx) {
            System.out.println("No biometric part uploaded or multipart parse error: " + partEx.getMessage());
        }

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement statement = null;
        ResultSet rsCheck = null;

        try {
            conn = SQLconnection.getconnection();
            if (conn == null) {
                response.sendRedirect("User_reg.jsp?failed=db_error");
                return;
            }

            // Check for duplicate registration by email
            checkStmt = conn.prepareStatement("SELECT id FROM user WHERE email = ?");
            checkStmt.setString(1, mail.trim());
            rsCheck = checkStmt.executeQuery();
            if (rsCheck.next()) {
                response.sendRedirect("User_reg.jsp?failed=duplicate");
                return;
            }

            String sql = "insert into user(name, email, dob, gender, phone, city, country, password, rpassword, time, kgc, otp, sign, val) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            statement = conn.prepareStatement(sql);
            statement.setString(1, name);
            statement.setString(2, mail);
            statement.setString(3, dob != null ? dob : "");
            statement.setString(4, gender != null ? gender : "Others");
            statement.setString(5, phone != null ? phone : "");
            statement.setString(6, city != null ? city : "");
            statement.setString(7, country != null ? country : "");
            statement.setString(8, pass);
            statement.setString(9, rpass != null ? rpass : pass);
            statement.setString(10, time);
            statement.setString(11, kgc);
            statement.setString(12, otp);

            if (inputStream != null) {
                statement.setBlob(13, inputStream);
            } else {
                statement.setNull(13, java.sql.Types.BLOB);
            }
            statement.setString(14, val);

            int row = statement.executeUpdate();
            if (row > 0) {
                response.sendRedirect("User.jsp?Successful");
            } else {
                response.sendRedirect("User_reg.jsp?failed");
            }
        } catch (Exception ex) {
            System.err.println("Registration error: " + ex.getMessage());
            ex.printStackTrace();
            response.sendRedirect("User_reg.jsp?failed=server_error");
        } finally {
            if (rsCheck != null) try { rsCheck.close(); } catch (Exception ignored) {}
            if (checkStmt != null) try { checkStmt.close(); } catch (Exception ignored) {}
            if (statement != null) try { statement.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
            if (inputStream != null) try { inputStream.close(); } catch (Exception ignored) {}
        }
    }
}