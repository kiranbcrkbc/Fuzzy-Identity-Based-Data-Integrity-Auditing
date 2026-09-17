<%-- 
    Document   : Auditing_request
    Created on : Nov 11, 2019, 10:53:01 AM
    Author     : java1
--%>

<%@page import="FUZZY.SQLconnection"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%
    String fid = request.getParameter("fid");
    if (fid == null || fid.trim().isEmpty()) {
        response.sendRedirect("audit_request.jsp?failed=missing_fid");
        return;
    }

    Connection con = null;
    PreparedStatement psSelect = null;
    PreparedStatement psInsert = null;
    PreparedStatement psUpdateFile = null;
    ResultSet rs = null;

    try {
        con = SQLconnection.getconnection();
        if (con == null) {
            response.sendRedirect("audit_request.jsp?failed=db_error");
            return;
        }

        psSelect = con.prepareStatement("SELECT * FROM fileupload WHERE filekey = ?");
        psSelect.setString(1, fid.trim());
        rs = psSelect.executeQuery();

        if (rs.next()) {
            String hash = rs.getString("hashcode");
            String uid = rs.getString("uid");

            DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            Date date = new Date();
            String time = dateFormat.format(date);

            psInsert = con.prepareStatement("INSERT INTO audit_request(filekey, time, uid, status, hash, hash_proof) VALUES(?, ?, ?, 'waiting', ?, 'waiting')");
            psInsert.setString(1, fid.trim());
            psInsert.setString(2, time);
            psInsert.setString(3, uid);
            psInsert.setString(4, hash);
            int i = psInsert.executeUpdate();

            // Update file status
            psUpdateFile = con.prepareStatement("UPDATE fileupload SET audit_status = 'Audit Challenge Sent' WHERE filekey = ?");
            psUpdateFile.setString(1, fid.trim());
            psUpdateFile.executeUpdate();

            if (i != 0) {
                response.sendRedirect("audit_request.jsp?requestsent");
            } else {
                response.sendRedirect("audit_request.jsp?failed");
            }
        } else {
            response.sendRedirect("audit_request.jsp?failed=not_found");
        }
    } catch (Exception ex) {
        System.err.println("Auditing_request error: " + ex.getMessage());
        ex.printStackTrace();
        response.sendRedirect("audit_request.jsp?failed");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (psSelect != null) try { psSelect.close(); } catch (Exception ignored) {}
        if (psInsert != null) try { psInsert.close(); } catch (Exception ignored) {}
        if (psUpdateFile != null) try { psUpdateFile.close(); } catch (Exception ignored) {}
        if (con != null) try { con.close(); } catch (Exception ignored) {}
    }
%>
