<%-- 
    Document   : pic
    Created on : Nov 12, 2019, 2:52:45 PM
    Author     : java1
--%>
<%-- 
    Document   : pic
    Created on : Oct 2, 2017, 10:18:49 AM
    Author     : java3
--%>
<%@page import="FUZZY.SQLconnection"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.OutputStream"%>

<%
    String id = request.getParameter("uid");
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    byte[] imgData = null;

    // 1x1 transparent GIF fallback
    byte[] fallbackGif = new byte[] { 71, 73, 70, 56, 57, 97, 1, 0, 1, 0, (byte)128, 0, 0, (byte)255, (byte)255, (byte)255, 0, 0, 0, 33, (byte)249, 4, 1, 0, 0, 0, 0, 44, 0, 0, 0, 0, 1, 0, 1, 0, 0, 2, 2, 68, 1, 0, 59 };

    if (id != null && !id.trim().isEmpty()) {
        try {
            con = SQLconnection.getconnection();
            if (con != null) {
                stmt = con.prepareStatement("SELECT sign FROM user WHERE id = ?");
                stmt.setString(1, id.trim());
                rs = stmt.executeQuery();
                if (rs.next()) {
                    Blob image = rs.getBlob("sign");
                    if (image != null && image.length() > 0) {
                        imgData = image.getBytes(1, (int) image.length());
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("pic.jsp error: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
            if (con != null) try { con.close(); } catch (Exception ignored) {}
        }
    }

    if (imgData == null || imgData.length == 0) {
        imgData = fallbackGif;
    }

    response.setContentType("image/png");
    response.setContentLength(imgData.length);
    try {
        OutputStream o = response.getOutputStream();
        o.write(imgData);
        o.flush();
    } catch (Exception ignored) {}
%>
