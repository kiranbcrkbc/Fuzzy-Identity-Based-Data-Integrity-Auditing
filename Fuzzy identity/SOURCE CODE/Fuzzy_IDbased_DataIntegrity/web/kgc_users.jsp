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
  <title>Registered Users & Biometrics | KGC Authority</title>
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
          <p>Registered Identity Directory</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="KGC_home.jsp">Dashboard</a></li>
        <li><a href="keyreq.jsp">Key Generation Requests</a></li>
        <li class="active"><a href="kgc_users.jsp">Registered Users</a></li>
        <li><a href="index.jsp" style="color: var(--rose-primary);">Logout</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div class="page-header-card">
      <div class="page-title-row">
        <div>
          <span class="role-badge kgc" style="margin-bottom: 10px;">Identity Repository</span>
          <h2 class="page-title">Registered User Directory & Biometrics</h2>
          <p class="page-subtitle">Inspect registered users, biometric template BLOBs, and issued Fuzzy Private Keys.</p>
        </div>
        <div>
          <a href="keyreq.jsp" class="btn btn-cyber" style="background: linear-gradient(135deg, var(--purple-primary), #6366f1); color: white;">
            &#128273; Key Requests
          </a>
        </div>
      </div>
    </div>

    <!-- Users Table -->
    <div class="cyber-card" style="margin-top: 24px;">
      <div class="card-header">
        <h3>&#128101; Registered Users & Biometric Signatures</h3>
        <span class="role-badge kgc">KGC Master Database</span>
      </div>
      <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
          <table class="cyber-table">
            <thead>
              <tr>
                <th>User ID</th>
                <th>Full Name</th>
                <th>Email Address</th>
                <th>Phone</th>
                <th>Biometric Template</th>
                <th>Fuzzy Private Key / Status</th>
              </tr>
            </thead>
            <tbody>
              <%
                  Connection con = SQLconnection.getconnection();
                  Statement st = con.createStatement();
                  int count = 0;
                  try {
                      ResultSet rs = st.executeQuery("Select * from user ORDER BY id DESC");
                      while (rs.next()) {
                          count++;
                          String kgcKey = rs.getString("kgc");
                          boolean isApproved = kgcKey != null && !kgcKey.equalsIgnoreCase("waiting");
              %>
              <tr>
                <td><span class="mono-code">UID-<%= rs.getString("id") %></span></td>
                <td><strong><%= rs.getString("name") %></strong></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getString("phone") != null ? rs.getString("phone") : "N/A" %></td>
                <td>
                  <img src="pic.jsp?uid=<%= rs.getString("id") %>" alt="Biometric Signature" style="height: 44px; max-width: 100px; border-radius: var(--radius-sm); border: 1px solid var(--border-color); background: rgba(255,255,255,0.05); object-fit: contain; padding: 2px;">
                </td>
                <td>
                  <% if (isApproved) { %>
                    <span class="mono-code" style="color: var(--purple-glow);"><%= kgcKey %></span>
                    <span class="badge-status success" style="margin-left: 6px;">Key Issued</span>
                  <% } else { %>
                    <span class="badge-status waiting">Pending Key Generation</span>
                  <% } %>
                </td>
              </tr>
              <%
                      }
                      if (count == 0) {
              %>
              <tr>
                <td colspan="6" style="text-align: center; padding: 36px; color: var(--text-muted);">
                  No registered users in database yet.
                </td>
              </tr>
              <%
                      }
                  } catch (Exception ex) {
              %>
              <tr>
                <td colspan="6" style="color: var(--rose-primary); padding: 20px;">Error loading users: <%= ex.getMessage() %></td>
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
