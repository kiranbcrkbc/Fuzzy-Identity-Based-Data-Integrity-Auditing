<%@page import="FUZZY.SQLconnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String votp = request.getParameter("votp");
    String mail = (String) session.getAttribute("umail");
    
    if (votp == null || votp.trim().isEmpty() || mail == null || mail.trim().isEmpty()) {
        response.sendRedirect("otp.jsp?Msg=Wrong_OTP_entered");
        return;
    }
    
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        con = SQLconnection.getconnection();
        if (con != null) {
            ps = con.prepareStatement("SELECT * FROM user WHERE otp = ? AND email = ?");
            ps.setString(1, votp.trim());
            ps.setString(2, mail.trim());
            rs = ps.executeQuery();
            if (rs.next()) {
                session.setAttribute("user_logged_in", "true");
                response.sendRedirect("User_home.jsp?Msg=login_successful");
            } else {
                response.sendRedirect("otp.jsp?Msg=Wrong_OTP_entered");
            }
        } else {
            response.sendRedirect("otp.jsp?Msg=Database_Connection_Error");
        }
    } catch (Exception ex) {
        ex.printStackTrace();
        response.sendRedirect("otp.jsp?Msg=Error");
    } finally {
        SQLconnection.close(con, ps, rs);
    }
%>
