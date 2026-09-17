<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="FUZZY.SQLconnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String uname = (String)session.getAttribute("uname");
    String uid = (String)session.getAttribute("uid");
    if (uname == null) {
        uname = "Data Owner";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Request Data Integrity Audit | Fuzzy Identity Auditing</title>
  <link rel="stylesheet" href="css/cyber_theme.css">
</head>
<body>

  <!-- Top Navigation Bar -->
  <nav class="cyber-navbar">
    <div class="app-container nav-wrapper">
      <a href="User_home.jsp" class="brand-logo">
        <div class="brand-icon">U</div>
        <div class="brand-text">
          <h1>USER PORTAL</h1>
          <p><%= uname %> &bull; Auditing Request</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="User_home.jsp">Dashboard</a></li>
        <li><a href="File_Upload.jsp">Upload File</a></li>
        <li><a href="MyFiles.jsp">My Files</a></li>
        <li class="active"><a href="audit_request.jsp">Request Audit</a></li>
        <li><a href="user_check.jsp">Audit Proofs</a></li>
        <li><a href="index.jsp" style="color: var(--rose-primary);">Logout</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div class="page-header-card">
      <div class="page-title-row">
        <div>
          <span class="role-badge amber" style="margin-bottom: 10px;">Third Party Verification</span>
          <h2 class="page-title">Initiate Data Integrity Audit</h2>
          <p class="page-subtitle">Select any stored cloud file to dispatch an auditing challenge to the Third Party Auditor (TPA).</p>
        </div>
      </div>
    </div>

    <% if (request.getParameter("requestsent") != null) { %>
      <div class="alert-banner success" style="margin-top: 20px;">
        <span>&#10004;</span>
        <div><strong>Audit Request Dispatched!</strong> The challenge has been queued for TPA verification.</div>
      </div>
    <% } %>

    <!-- Table Card -->
    <div class="cyber-card" style="margin-top: 24px;">
      <div class="card-header">
        <h3>&#128270; Select Cloud Document to Audit</h3>
        <span class="role-badge user">Data Owner: <%= uname %></span>
      </div>
      <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
          <table class="cyber-table">
            <thead>
              <tr>
                <th>File ID</th>
                <th>Document Title</th>
                <th>Upload Timestamp</th>
                <th>Hash Code</th>
                <th>Current Status</th>
                <th style="text-align: right;">Action</th>
              </tr>
            </thead>
            <tbody>
              <%
                  Connection con = SQLconnection.getconnection();
                  Statement st = con.createStatement();
                  int count = 0;
                  try {
                      String query = (uid != null && !uid.isEmpty()) ? "Select * from fileupload where uid ='" + uid + "' ORDER BY id DESC" : "Select * from fileupload ORDER BY id DESC";
                      ResultSet rs = st.executeQuery(query);
                      while (rs.next()) {
                          count++;
                          String auditStatus = rs.getString("audit_status");
                          String badgeClass = "neutral";
                          if (auditStatus != null && auditStatus.toLowerCase().contains("success")) {
                              badgeClass = "success";
                          } else if (auditStatus != null && auditStatus.toLowerCase().contains("sent")) {
                              badgeClass = "pending";
                          }
              %>
              <tr>
                <td><span class="mono-code"><%= rs.getString("filekey") %></span></td>
                <td><strong><%= rs.getString("fname") %></strong></td>
                <td><%= rs.getString("time") %></td>
                <td><span class="mono-code" style="color: var(--cyan-glow);"><%= rs.getString("hashcode") %></span></td>
                <td>
                  <span class="badge-status <%= badgeClass %>">
                    <%= auditStatus != null ? auditStatus.trim() : "Not Audited Yet" %>
                  </span>
                </td>
                <td style="text-align: right;">
                  <a href="Auditing_request.jsp?fid=<%= rs.getString("filekey") %>" class="btn btn-cyber btn-sm">
                    &#128270; Request Audit &rarr;
                  </a>
                </td>
              </tr>
              <%
                      }
                      if (count == 0) {
              %>
              <tr>
                <td colspan="6" style="text-align: center; padding: 36px; color: var(--text-muted);">
                  No stored files found. <a href="File_Upload.jsp" style="color: var(--cyan-glow); font-weight: 600;">Upload a file</a> to perform integrity auditing.
                </td>
              </tr>
              <%
                      }
                  } catch (Exception ex) {
              %>
              <tr>
                <td colspan="6" style="color: var(--rose-primary); padding: 20px;">Error loading files: <%= ex.getMessage() %></td>
              </tr>
              <%
                  }
              %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </main>

  <!-- Footer -->
  <footer class="cyber-footer">
    <div class="app-container">
      <p><strong>Department of Computer Science & Engineering</strong> &bull; R R Institute of Technology</p>
    </div>
  </footer>

</body>
</html>
