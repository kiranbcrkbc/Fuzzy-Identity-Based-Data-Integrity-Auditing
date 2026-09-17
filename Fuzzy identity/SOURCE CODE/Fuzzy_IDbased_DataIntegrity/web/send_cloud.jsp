<%-- 
    Document   : send_cloud
    Created on : Nov 11, 2019, 10:57:51 AM
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
    String uid = request.getParameter("uid");
    String fid = request.getParameter("fid");

    if (uid == null || fid == null || uid.trim().isEmpty() || fid.trim().isEmpty()) {
        response.sendRedirect("TPA_audit_request.jsp?request_failed");
        return;
    }

    Connection con = null;
    PreparedStatement psAuditUpdate = null;
    PreparedStatement psFileSelect = null;
    PreparedStatement psCloudInsert = null;
    ResultSet rs = null;

    try {
        con = SQLconnection.getconnection();
        if (con == null) {
            response.sendRedirect("TPA_audit_request.jsp?request_failed");
            return;
        }

        psAuditUpdate = con.prepareStatement("UPDATE audit_request SET status='sent' WHERE uid = ? AND filekey = ?");
        psAuditUpdate.setString(1, uid.trim());
        psAuditUpdate.setString(2, fid.trim());
        psAuditUpdate.executeUpdate();

        psFileSelect = con.prepareStatement("SELECT * FROM fileupload WHERE uid = ? AND filekey = ?");
        psFileSelect.setString(1, uid.trim());
        psFileSelect.setString(2, fid.trim());
        rs = psFileSelect.executeQuery();

        if (rs.next()) {
            DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            Date date = new Date();
            String time = dateFormat.format(date);

            psCloudInsert = con.prepareStatement("INSERT INTO cloud_request(filekey, time, uid, status) VALUES(?, ?, ?, 'waiting')");
            psCloudInsert.setString(1, fid.trim());
            psCloudInsert.setString(2, time);
            psCloudInsert.setString(3, uid.trim());
            int i = psCloudInsert.executeUpdate();

            if (i != 0) {
                response.sendRedirect("TPA_audit_request.jsp?requestsent");
            } else {
                response.sendRedirect("TPA_audit_request.jsp?request_failed");
            }
        } else {
            response.sendRedirect("TPA_audit_request.jsp?request_failed");
        }
    } catch (Exception ex) {
        System.err.println("send_cloud error: " + ex.getMessage());
        ex.printStackTrace();
        response.sendRedirect("TPA_audit_request.jsp?request_failed");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (psAuditUpdate != null) try { psAuditUpdate.close(); } catch (Exception ignored) {}
        if (psFileSelect != null) try { psFileSelect.close(); } catch (Exception ignored) {}
        if (psCloudInsert != null) try { psCloudInsert.close(); } catch (Exception ignored) {}
        if (con != null) try { con.close(); } catch (Exception ignored) {}
    }
%>
