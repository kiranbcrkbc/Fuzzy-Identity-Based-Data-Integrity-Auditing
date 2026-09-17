<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="FUZZY.SQLconnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Stored Files in Cloud | Cloud Service Provider</title>
  <link rel="stylesheet" href="css/cyber_theme.css">
</head>
<body>

  <!-- Top Navigation Bar -->
  <nav class="cyber-navbar">
    <div class="app-container nav-wrapper">
      <a href="cloud_home.jsp" class="brand-logo">
        <div class="brand-icon" style="background: linear-gradient(135deg, var(--emerald-primary), #059669);">&#9729;</div>
        <div class="brand-text">
          <h1>CLOUD SERVICE PROVIDER</h1>
          <p>Global Stored Files</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="cloud_home.jsp">Dashboard</a></li>
        <li><a href="cloud_audit.jsp">Process Audits & Proofs</a></li>
        <li class="active"><a href="All_files.jsp">Stored Files in Cloud</a></li>
        <li><a href="index.jsp" style="color: var(--rose-primary);">Logout</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div class="page-header-card">
      <div class="page-title-row">
        <div>
          <span class="role-badge cloud" style="margin-bottom: 10px;">Cloud Repository</span>
          <h2 class="page-title">All Encrypted Files in Cloud Storage</h2>
          <p class="page-subtitle">Inspect the complete repository of encrypted documents, file keys, and homomorphic integrity tags.</p>
        </div>
      </div>
    </div>

    <!-- Table Card -->
    <div class="cyber-card" style="margin-top: 24px;">
      <div class="card-header">
        <h3>&#128451; Cloud Storage Document Index</h3>
        <span class="role-badge cloud">All Data Owners</span>
      </div>
      <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
          <table class="cyber-table">
            <thead>
              <tr>
                <th>Data Owner ID</th>
                <th>File Key</th>
                <th>Upload Timestamp</th>
                <th>Integrity Hash Code</th>
                <th>Auditing State</th>
              </tr>
            </thead>
            <tbody>
              <%
                  Connection con = SQLconnection.getconnection();
                  Statement st = con.createStatement();
                  int count = 0;
                  try {
                      ResultSet rs = st.executeQuery("Select * from fileupload ORDER BY id DESC");
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
                <td><span class="mono-code">UID-<%= rs.getString("uid") %></span></td>
                <td><span class="mono-code" style="color: var(--cyan-glow);"><%= rs.getString("filekey") %></span></td>
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
                <td colspan="5" style="text-align: center; padding: 36px; color: var(--text-muted);">
                  No files stored in cloud repository yet.
                </td>
              </tr>
              <%
                      }
                  } catch (Exception ex) {
              %>
              <tr>
                <td colspan="5" style="color: var(--rose-primary); padding: 20px;">Error loading files: <%= ex.getMessage() %></td>
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
