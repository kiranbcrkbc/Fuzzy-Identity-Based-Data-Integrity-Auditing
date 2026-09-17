<%-- 
    Document   : sendkey
    Created on : Nov 9, 2019, 1:09:33 PM
    Author     : java1
--%>
<%@page import="FUZZY.Mail"%>
<%@page import="FUZZY.SQLconnection"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>

<%
    String uid = request.getParameter("uid");
    String mail = request.getParameter("mid");

    if (uid == null || uid.trim().isEmpty()) {
        response.sendRedirect("keyreq.jsp?msg=Invalid_User_ID");
        return;
    }

    Connection conn = null;
    PreparedStatement psSelect = null;
    PreparedStatement psUpdate = null;
    ResultSet rs = null;

    try {
        conn = SQLconnection.getconnection();
        if (conn == null) {
            response.sendRedirect("keyreq.jsp?msg=DB_Error");
            return;
        }

        psSelect = conn.prepareStatement("SELECT val, email FROM user WHERE id = ?");
        psSelect.setString(1, uid.trim());
        rs = psSelect.executeQuery();

        if (rs.next()) {
            String bio = rs.getString("val");
            if (bio == null) bio = "0";
            if (mail == null || mail.trim().isEmpty()) {
                mail = rs.getString("email");
            }

            SecureRandom RANDOM = new SecureRandom();
            int PASSWORD_LENGTH = 4;
            String letters = "0123456789";
            StringBuilder idBuilder = new StringBuilder();
            for (int i = 0; i < PASSWORD_LENGTH; i++) {
                int index = (int) (RANDOM.nextDouble() * letters.length());
                idBuilder.append(letters.charAt(index));
            }
            String kgcid = "FUZZY" + bio + idBuilder.toString();

            psUpdate = conn.prepareStatement("UPDATE user SET kgc = ? WHERE id = ?");
            psUpdate.setString(1, kgcid);
            psUpdate.setString(2, uid.trim());
            int i = psUpdate.executeUpdate();

            if (i != 0) {
                String msggg = "Private Key: " + kgcid;
                try {
                    if (mail != null) {
                        Mail.secretMail(msggg, "Downloadkey", mail.trim());
                    }
                } catch (Exception mailEx) {
                    System.out.println("Mail dispatch skipped: " + mailEx.getMessage());
                }
                response.sendRedirect("kgc_request.jsp?msg=Key_Sent");
            } else {
                response.sendRedirect("kgc_request.jsp?msg=Key_gen_Failed");
            }
        } else {
            response.sendRedirect("keyreq.jsp?msg=User_Not_Found");
        }
    } catch (Exception ex) {
        System.err.println("sendkey error: " + ex.getMessage());
        ex.printStackTrace();
        response.sendRedirect("kgc_request.jsp?msg=Key_gen_Failed");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (psSelect != null) try { psSelect.close(); } catch (Exception ignored) {}
        if (psUpdate != null) try { psUpdate.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>

