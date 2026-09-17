<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="FUZZY.SQLconnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Key Generation Requests | KGC Authority</title>
  <link rel="stylesheet" href="css/cyber_theme.css">
</head>
<body>

  <!-- Top Navigation Bar -->
  <nav class="cyber-navbar">
    <div class="app-container nav-wrapper">
      <a href="KGC_home.jsp" class="brand-logo">
        <div class="brand-icon" style="background: linear-gradient(135deg, var(--purple-primary), var(--cyan-primary));">K</div>
        <div class="brand-text">
          <h1>KGC AUTHORITY</h1>
          <p>Key Generation Requests</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="KGC_home.jsp">Dashboard</a></li>
        <li class="active"><a href="keyreq.jsp">Key Generation Requests</a></li>
        <li><a href="kgc_users.jsp">Registered Users</a></li>
        <li><a href="index.jsp" style="color: var(--rose-primary);">Logout</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div class="page-header-card">
      <div class="page-title-row">
        <div>
          <span class="role-badge kgc" style="margin-bottom: 10px;">Private Key Generation</span>
          <h2 class="page-title">Pending Identity Key Requests</h2>
          <p class="page-subtitle">Verify user biometric templates and generate Fuzzy Identity-Based Private Keys.</p>
        </div>
      </div>
    </div>

    <% if (request.getParameter("msg") != null) { %>
      <div class="alert-banner success" style="margin-top: 20px;">
        <span>&#10004;</span>
        <div><strong>Status Update:</strong> <%= request.getParameter("msg") %></div>
      </div>
    <% } %>

    <!-- Table Card -->
    <div class="cyber-card" style="margin-top: 24px;">
      <div class="card-header">
        <h3>&#128273; Authorization Queue</h3>
        <span class="role-badge kgc">Awaiting Approval</span>
      </div>
      <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
          <table class="cyber-table">
            <thead>
              <tr>
                <th>Data Owner Name</th>
                <th>Email Address</th>
                <th>Registration Status</th>
                <th>Biometric Template</th>
                <th style="text-align: right;">Action</th>
              </tr>
            </thead>
            <tbody>
              <%
                  Connection con = SQLconnection.getconnection();
                  Statement st = con.createStatement();
                  int count = 0;
                  try {
                      ResultSet rs = st.executeQuery("Select * from user where kgc='waiting' ORDER BY id DESC");
                      while (rs.next()) {
                          count++;
              %>
              <tr>
                <td><strong><%= rs.getString("name") %></strong></td>
                <td><%= rs.getString("email") %></td>
                <td><span class="badge-status waiting"><%= rs.getString("kgc") %></span></td>
                <td>
                  <img src="pic.jsp?uid=<%= rs.getString("id") %>" alt="Biometric Signature" style="height: 44px; max-width: 100px; border-radius: var(--radius-sm); border: 1px solid var(--border-color); background: rgba(255,255,255,0.05); object-fit: contain; padding: 2px;">
                </td>
                <td style="text-align: right;">
                  <a href="sendkey.jsp?mid=<%= rs.getString("email") %>&time=<%= rs.getString("time") %>&uid=<%= rs.getString("id") %>" class="btn btn-cyber btn-sm" style="background: linear-gradient(135deg, var(--purple-primary), #6366f1); color: white;">
                    &#128273; Generate & Send Key &rarr;
                  </a>
                </td>
              </tr>
              <%
                      }
                      if (count == 0) {
              %>
              <tr>
                <td colspan="5" style="text-align: center; padding: 36px; color: var(--text-muted);">
                  No pending key generation requests. All registered users have been verified and approved!
                </td>
              </tr>
              <%
                      }
                  } catch (Exception ex) {
              %>
              <tr>
                <td colspan="5" style="color: var(--rose-primary); padding: 20px;">Error loading requests: <%= ex.getMessage() %></td>
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
