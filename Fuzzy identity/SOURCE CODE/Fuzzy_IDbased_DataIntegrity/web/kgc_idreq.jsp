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
  <title>Identity Records | KGC Authority</title>
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
          <p>Key Generation Center &bull; Identity Registry</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="KGC_home.jsp">Dashboard</a></li>
        <li><a href="keyreq.jsp">Key Requests</a></li>
        <li><a href="kgc_users.jsp">Registered Users</a></li>
        <li class="active"><a href="kgc_idreq.jsp">Identity Records</a></li>
        <li><a href="index.jsp" style="color: var(--rose-primary);">Logout</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div class="page-header-card">
      <div class="page-title-row">
        <div>
          <span class="role-badge kgc" style="margin-bottom: 10px;">Master Cryptographic Registry</span>
          <h2 class="page-title">Biometric Identity Records</h2>
          <p class="page-subtitle">Complete registry of user identities, location attributes, and issued Fuzzy Identity keys.</p>
        </div>
        <div>
          <a href="keyreq.jsp" class="btn btn-cyber" style="background: linear-gradient(135deg, var(--purple-primary), #6366f1); color: white;">
            &#128273; Review Pending Requests &rarr;
          </a>
        </div>
      </div>
    </div>

    <div class="cyber-card" style="margin-top: 24px;">
      <div class="card-header">
        <h3>&#128203; User Identity Ledger</h3>
        <span class="role-badge kgc">KGC Ledger</span>
      </div>
      <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
          <table class="cyber-table">
            <thead>
              <tr>
                <th>Identity Key / Status</th>
                <th>Full Name</th>
                <th>Email Address</th>
                <th>Date of Birth</th>
                <th>Gender</th>
                <th>Phone</th>
                <th>City</th>
                <th>Country</th>
              </tr>
            </thead>
            <tbody>
              <%
                  Connection con = null;
                  Statement st = null;
                  ResultSet rs = null;
                  int count = 0;
                  try {
                      con = SQLconnection.getconnection();
                      if (con != null) {
                          st = con.createStatement();
                          rs = st.executeQuery("SELECT * FROM user ORDER BY id DESC");
                          while (rs.next()) {
                              count++;
                              String kgcKey = rs.getString("kgc");
                              boolean isApproved = kgcKey != null && !kgcKey.equalsIgnoreCase("waiting");
              %>
              <tr>
                <td>
                  <% if (isApproved) { %>
                    <span class="mono-code" style="color: var(--purple-glow);"><%= kgcKey %></span>
                  <% } else { %>
                    <span class="badge-status waiting">Pending</span>
                  <% } %>
                </td>
                <td><strong><%= rs.getString("name") %></strong></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getString("dob") != null ? rs.getString("dob") : "N/A" %></td>
                <td><%= rs.getString("gender") != null ? rs.getString("gender") : "N/A" %></td>
                <td><%= rs.getString("phone") != null ? rs.getString("phone") : "N/A" %></td>
                <td><%= rs.getString("city") != null ? rs.getString("city") : "N/A" %></td>
                <td><%= rs.getString("country") != null ? rs.getString("country") : "N/A" %></td>
              </tr>
              <%
                          }
                      }
                      if (count == 0) {
              %>
              <tr>
                <td colspan="8" style="text-align: center; padding: 36px; color: var(--text-muted);">
                  No user identities registered in repository yet.
                </td>
              </tr>
              <%
                      }
                  } catch (Exception ex) {
              %>
              <tr>
                <td colspan="8" style="color: var(--rose-primary); padding: 20px;">Error loading user ledger: <%= ex.getMessage() %></td>
              </tr>
              <%
                  } finally {
                      SQLconnection.close(con, st, rs);
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
