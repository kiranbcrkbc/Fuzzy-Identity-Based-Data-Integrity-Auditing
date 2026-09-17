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
  <title>Cloud Audit Challenges | Cloud Service Provider</title>
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
          <p>Proof Computation Engine</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="cloud_home.jsp">Dashboard</a></li>
        <li class="active"><a href="cloud_audit.jsp">Process Audits & Proofs</a></li>
        <li><a href="All_files.jsp">Stored Files in Cloud</a></li>
        <li><a href="index.jsp" style="color: var(--rose-primary);">Logout</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div class="page-header-card">
      <div class="page-title-row">
        <div>
          <span class="role-badge cloud" style="margin-bottom: 10px;">Homomorphic Proof Engine</span>
          <h2 class="page-title">Pending Cloud Audit Challenges</h2>
          <p class="page-subtitle">Calculate cryptographic integrity proofs for challenged file blocks and transmit verification hashes to the auditor.</p>
        </div>
      </div>
    </div>

    <% if (request.getParameter("msg") != null) { %>
      <div class="alert-banner success" style="margin-top: 20px;">
        <span>&#10004;</span>
        <div><strong>Proof Generated & Dispatched!</strong> Cryptographic proof hash recorded and audit status updated.</div>
      </div>
    <% } %>

    <!-- Table Card -->
    <div class="cyber-card" style="margin-top: 24px;">
      <div class="card-header">
        <h3>&#9889; Incoming TPA Challenges</h3>
        <span class="role-badge cloud">Awaiting Proof Computation</span>
      </div>
      <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
          <table class="cyber-table">
            <thead>
              <tr>
                <th>Data Owner ID</th>
                <th>Challenged File Key</th>
                <th>Challenge Timestamp</th>
                <th style="text-align: right;">Action</th>
              </tr>
            </thead>
            <tbody>
              <%
                  Connection con = SQLconnection.getconnection();
                  Statement st = con.createStatement();
                  int count = 0;
                  try {
                      ResultSet rs = st.executeQuery("Select * from cloud_request where status='waiting' ORDER BY id DESC");
                      while (rs.next()) {
                          count++;
              %>
              <tr>
                <td><span class="mono-code">UID-<%= rs.getString("uid") %></span></td>
                <td><span class="mono-code" style="color: var(--cyan-glow);"><%= rs.getString("filekey") %></span></td>
                <td><%= rs.getString("time") %></td>
                <td style="text-align: right;">
                  <a href="audit_proof.jsp?fid=<%= rs.getString("filekey") %>&time=<%= rs.getString("time") %>&did=<%= rs.getString("uid") %>" class="btn btn-emerald btn-sm">
                    &#9889; Compute & Send Proof &rarr;
                  </a>
                </td>
              </tr>
              <%
                      }
                      if (count == 0) {
              %>
              <tr>
                <td colspan="4" style="text-align: center; padding: 36px; color: var(--text-muted);">
                  No pending audit challenges. All storage blocks are verified.
                </td>
              </tr>
              <%
                      }
                  } catch (Exception ex) {
              %>
              <tr>
                <td colspan="4" style="color: var(--rose-primary); padding: 20px;">Error loading challenges: <%= ex.getMessage() %></td>
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
