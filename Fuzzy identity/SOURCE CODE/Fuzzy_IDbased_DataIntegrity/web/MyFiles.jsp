<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
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
  <title>My Files | Fuzzy Identity-Based Auditing</title>
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
          <p><%= uname %> &bull; My Files</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="User_home.jsp">Dashboard</a></li>
        <li><a href="File_Upload.jsp">Upload File</a></li>
        <li class="active"><a href="MyFiles.jsp">My Files</a></li>
        <li><a href="audit_request.jsp">Request Audit</a></li>
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
          <span class="role-badge user" style="margin-bottom: 10px;">Encrypted Repository</span>
          <h2 class="page-title">My Stored Cloud Files</h2>
          <p class="page-subtitle">View all encrypted documents, dynamic file keys, and cryptographic integrity hashes.</p>
        </div>
        <div>
          <a href="File_Upload.jsp" class="btn btn-cyber">&#43; Upload New File</a>
        </div>
      </div>
    </div>

    <!-- Table Card -->
    <div class="cyber-card" style="margin-top: 24px;">
      <div class="card-header">
        <h3>&#128193; File Repository Index</h3>
        <span class="role-badge user">User ID: <%= uid != null ? uid : "All" %></span>
      </div>
      <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
          <table class="cyber-table">
            <thead>
              <tr>
                <th>File ID / Key</th>
                <th>Document Title</th>
                <th>Owner</th>
                <th>Upload Timestamp</th>
                <th>Integrity Hash Code</th>
                <th>Auditing Status</th>
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
                <td><strong><%= rs.getString("fname") %></strong><br><small style="color: var(--text-muted);"><%= rs.getString("filename") %></small></td>
                <td><%= rs.getString("user") %></td>
                <td><%= rs.getString("time") %></td>
                <td><span class="mono-code" style="color: var(--emerald-glow);"><%= rs.getString("hashcode") %></span></td>
                <td>
                  <span class="badge-status <%= badgeClass %>">
                    <%= auditStatus != null ? auditStatus.trim() : "Not Audited Yet" %>
                  </span>
                </td>
              </tr>
              <%
                      }
                      if (count == 0) {
              %>
              <tr>
                <td colspan="6" style="text-align: center; padding: 36px; color: var(--text-muted);">
                  No files uploaded yet. Click <a href="File_Upload.jsp" style="color: var(--cyan-glow); font-weight: 600;">here</a> to upload and encrypt your first document.
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
