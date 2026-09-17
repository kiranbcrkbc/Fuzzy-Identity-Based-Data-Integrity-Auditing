<%-- 
    Document   : user_login
    Created on : Nov 9, 2019, 11:43:05 AM
    Author     : java1
--%>

<%@page import="FUZZY.Mail"%>
<%@page import="FUZZY.SQLconnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="java.util.Random"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%
    String mail = request.getParameter("email");
    String pass = request.getParameter("pass");

    if (mail == null || mail.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
        response.sendRedirect("User.jsp?Msg=Authentication_Failed");
        return;
    }

    Connection con = null;
    PreparedStatement psCheck = null;
    PreparedStatement psUpdate = null;
    ResultSet rs = null;

    try {
        con = SQLconnection.getconnection();
        if (con == null) {
            response.sendRedirect("User.jsp?Msg=DB_Connection_Error");
            return;
        }

        psCheck = con.prepareStatement("SELECT * FROM user WHERE email = ?");
        psCheck.setString(1, mail.trim());
        rs = psCheck.executeQuery();

        if (rs.next()) {
            String storedPassword = rs.getString("password");
            String kgcStatus = rs.getString("kgc");

            if (!pass.equals(storedPassword)) {
                response.sendRedirect("User.jsp?Msg=Authentication_Failed");
                return;
            }

            if (kgcStatus == null || "waiting".equalsIgnoreCase(kgcStatus.trim())) {
                response.sendRedirect("User.jsp?Msg=Pending_KGC_Approval");
                return;
            }

            session.setAttribute("uname", rs.getString("name"));
            session.setAttribute("umail", rs.getString("email"));
            session.setAttribute("uid", String.valueOf(rs.getInt("id")));

            Random RANDOM = new SecureRandom();
            int PASSWORD_LENGTH = 5;
            String letters = "0123456789";
            StringBuilder otpBuilder = new StringBuilder();
            for (int i = 0; i < PASSWORD_LENGTH; i++) {
                int index = (int) (RANDOM.nextDouble() * letters.length());
                otpBuilder.append(letters.charAt(index));
            }
            String filekey = "I" + otpBuilder.toString();

            psUpdate = con.prepareStatement("UPDATE user SET otp = ? WHERE email = ?");
            psUpdate.setString(1, filekey);
            psUpdate.setString(2, mail.trim());
            psUpdate.executeUpdate();

            String msggg = "Your 6 digit OTP : " + filekey;
            try {
                Mail.secretMail(msggg, "Downloadkey", mail.trim());
            } catch (Exception mailEx) {
                System.out.println("Mail dispatch skipped: " + mailEx.getMessage());
            }

            response.sendRedirect("otp.jsp?Msg=otp");
        } else {
            response.sendRedirect("User.jsp?Msg=Authentication_Failed");
        }
    } catch (Exception ex) {
        System.err.println("Login error: " + ex.getMessage());
        ex.printStackTrace();
        response.sendRedirect("User.jsp?Msg=Authentication_Failed");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (psCheck != null) try { psCheck.close(); } catch (Exception ignored) {}
        if (psUpdate != null) try { psUpdate.close(); } catch (Exception ignored) {}
        if (con != null) try { con.close(); } catch (Exception ignored) {}
    }
%>
