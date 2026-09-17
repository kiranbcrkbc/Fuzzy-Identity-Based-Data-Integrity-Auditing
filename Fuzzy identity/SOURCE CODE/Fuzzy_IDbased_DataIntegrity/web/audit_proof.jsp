<%@page import="FUZZY.SQLconnection"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%
    String fid = request.getParameter("fid");
    String uid = request.getParameter("did");

    if (fid == null || fid.trim().isEmpty()) {
        response.sendRedirect("cloud_audit.jsp?msg=Proof_failed");
        return;
    }

    Connection con = null;
    PreparedStatement psCloudReq = null;
    PreparedStatement psFile = null;
    PreparedStatement psAuditReq = null;
    PreparedStatement psFileStatus = null;
    PreparedStatement psProofInsert = null;
    ResultSet rs = null;

    try {
        con = SQLconnection.getconnection();
        if (con == null) {
            response.sendRedirect("cloud_audit.jsp?msg=Proof_failed");
            return;
        }

        psCloudReq = con.prepareStatement("UPDATE cloud_request SET status = 'Proof Sent' WHERE filekey = ?");
        psCloudReq.setString(1, fid.trim());
        psCloudReq.executeUpdate();

        psFile = con.prepareStatement("SELECT hashcode, uid FROM fileupload WHERE filekey = ?");
        psFile.setString(1, fid.trim());
        rs = psFile.executeQuery();

        if (rs.next()) {
            String hash = rs.getString("hashcode");
            if (uid == null || uid.trim().isEmpty()) {
                uid = rs.getString("uid");
            }

            DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            Date date = new Date();
            String time = dateFormat.format(date);

            psAuditReq = con.prepareStatement("UPDATE audit_request SET hash_proof = ? WHERE filekey = ?");
            psAuditReq.setString(1, hash);
            psAuditReq.setString(2, fid.trim());
            psAuditReq.executeUpdate();

            psFileStatus = con.prepareStatement("UPDATE fileupload SET audit_status = 'Audition Success' WHERE filekey = ?");
            psFileStatus.setString(1, fid.trim());
            psFileStatus.executeUpdate();

            psProofInsert = con.prepareStatement("INSERT INTO audit_proof(filekey, time, uid, hashproof) VALUES(?, ?, ?, ?)");
            psProofInsert.setString(1, fid.trim());
            psProofInsert.setString(2, time);
            psProofInsert.setString(3, uid != null ? uid.trim() : "1");
            psProofInsert.setString(4, hash);
            int i = psProofInsert.executeUpdate();

            if (i != 0) {
                response.sendRedirect("cloud_audit.jsp?msg=Proof_sent");
            } else {
                response.sendRedirect("cloud_audit.jsp?msg=Proof_failed");
            }
        } else {
            response.sendRedirect("cloud_audit.jsp?msg=Proof_failed");
        }
    } catch (Exception ex) {
        System.err.println("audit_proof error: " + ex.getMessage());
        ex.printStackTrace();
        response.sendRedirect("cloud_audit.jsp?msg=Proof_failed");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (psCloudReq != null) try { psCloudReq.close(); } catch (Exception ignored) {}
        if (psFile != null) try { psFile.close(); } catch (Exception ignored) {}
        if (psAuditReq != null) try { psAuditReq.close(); } catch (Exception ignored) {}
        if (psFileStatus != null) try { psFileStatus.close(); } catch (Exception ignored) {}
        if (psProofInsert != null) try { psProofInsert.close(); } catch (Exception ignored) {}
        if (con != null) try { con.close(); } catch (Exception ignored) {}
    }
%>