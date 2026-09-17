<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="FUZZY.SQLconnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Audit Requests | TPA Control Suite</title>
  <link rel="stylesheet" href="css/cyber_theme.css">
</head>
<body>

  <!-- Top Navigation Bar -->
  <nav class="cyber-navbar">
    <div class="app-container nav-wrapper">
      <a href="TPA_home.jsp" class="brand-logo">
        <div class="brand-icon" style="background: linear-gradient(135deg, var(--amber-primary), #d97706);">T</div>
        <div class="brand-text">
          <h1>TPA AUDITING SUITE</h1>
          <p>Audit Request Queue</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="TPA_home.jsp">Dashboard</a></li>
        <li class="active"><a href="TPA_audit_request.jsp">User Audit Requests</a></li>
        <li><a href="cloud_req.jsp">Cloud Challenges</a></li>
        <li><a href="proof_Check.jsp">Auditing Proofs</a></li>
        <li><a href="index.jsp" style="color: var(--rose-primary);">Logout</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div class="page-header-card">
      <div class="page-title-row">
        <div>
          <span class="role-badge tpa" style="margin-bottom: 10px;">Audit Pipeline</span>
          <h2 class="page-title">Incoming User Audit Requests</h2>
          <p class="page-subtitle">Inspect client audit challenges and issue homomorphic challenge vectors to the Cloud Storage Server.</p>
        </div>
      </div>
    </div>

    <% if (request.getParameter("requestsent") != null) { %>
      <div class="alert-banner success" style="margin-top: 20px;">
        <span>&#10004;</span>
        <div><strong>Challenge Dispatched to Cloud!</strong> The audit challenge is now queued on the Cloud Server for proof generation.</div>
      </div>
    <% } %>

    <!-- Table Card -->
    <div class="cyber-card" style="margin-top: 24px;">
      <div class="card-header">
        <h3>&#128233; Pending Audit Queue</h3>
        <span class="role-badge tpa">Awaiting TPA Challenge</span>
      </div>
      <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
          <table class="cyber-table">
            <thead>
              <tr>
                <th>Data Owner ID</th>
                <th>File Key</th>
                <th>Integrity Hash</th>
                <th>Request Timestamp</th>
                <th style="text-align: right;">Action</th>
              </tr>
            </thead>
            <tbody>
              <%
                  Connection con = SQLconnection.getconnection();
                  Statement st = con.createStatement();
                  int count = 0;
                  try {
                      ResultSet rs = st.executeQuery("Select * from audit_request where status='waiting' ORDER BY id DESC");
                      while (rs.next()) {
                          count++;
              %>
              <tr>
                <td><span class="mono-code">UID-<%= rs.getString("uid") %></span></td>
                <td><span class="mono-code" style="color: var(--cyan-glow);"><%= rs.getString("filekey") %></span></td>
                <td><span class="mono-code" style="color: #fbbf24;"><%= rs.getString("hash") %></span></td>
                <td><%= rs.getString("time") %></td>
                <td style="text-align: right;">
                  <a href="send_cloud.jsp?uid=<%= rs.getString("uid") %>&fid=<%= rs.getString("filekey") %>" class="btn btn-cyber btn-sm" style="background: linear-gradient(135deg, var(--amber-primary), #d97706); color: #0b0f19; font-weight: 700;">
                    &#9729; Send Challenge to Cloud &rarr;
                  </a>
                </td>
              </tr>
              <%
                      }
                      if (count == 0) {
              %>
              <tr>
                <td colspan="5" style="text-align: center; padding: 36px; color: var(--text-muted);">
                  No pending audit requests from Data Owners at this time.
                </td>
              </tr>
              <%
                      }
                  } catch (Exception ex) {
              %>
              <tr>
                <td colspan="5" style="color: var(--rose-primary); padding: 20px;">Error loading audit requests: <%= ex.getMessage() %></td>
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
