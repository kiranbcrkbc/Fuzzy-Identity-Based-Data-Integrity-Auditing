<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TPA Login | Third Party Auditor</title>
  <link rel="stylesheet" href="css/cyber_theme.css">
</head>
<body>

  <!-- Top Navigation Bar -->
  <nav class="cyber-navbar">
    <div class="app-container nav-wrapper">
      <a href="index.jsp" class="brand-logo">
        <div class="brand-icon" style="background: linear-gradient(135deg, var(--amber-primary), #d97706);">T</div>
        <div class="brand-text">
          <h1>THIRD PARTY AUDITOR</h1>
          <p>Public Integrity Verifier</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="User.jsp">User Portal</a></li>
        <li><a href="KGC.jsp">KGC Portal</a></li>
        <li class="active"><a href="TPA.jsp">TPA Portal</a></li>
        <li><a href="Cloud.jsp">Cloud Server</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div style="max-width: 480px; margin: 40px auto;">

      <% if (request.getParameter("failed") != null) { %>
        <div class="alert-banner error">
          <span>&#9888;</span>
          <div><strong>Invalid Auditor Credentials:</strong> Please verify TPA username and password.</div>
        </div>
      <% } %>

      <div class="cyber-card">
        <div class="card-header">
          <h3>&#128270; Third Party Auditor Login</h3>
          <span class="role-badge tpa">Public Verifier</span>
        </div>
        <div class="card-body">
          <form action="TPA" method="post">
            
            <div class="form-group">
              <label for="tpa">Auditor ID / Username</label>
              <input id="tpa" type="text" name="tpa" class="form-control" placeholder="Enter TPA ID (Default: TPA)" required autocomplete="username">
            </div>

            <div class="form-group">
              <label for="password">Auditor Access Key / Password</label>
              <input id="password" type="password" name="password" class="form-control" placeholder="Enter TPA password (Default: TPA)" required autocomplete="current-password">
            </div>

            <div style="margin-top: 24px;">
              <button type="submit" class="btn btn-cyber" style="width: 100%; background: linear-gradient(135deg, var(--amber-primary), #d97706); color: #0b0f19; font-weight: 700;">
                Authenticate Auditor Portal &rarr;
              </button>
            </div>

            <div style="margin-top: 20px; text-align: center; border-top: 1px solid var(--border-color); padding-top: 16px;">
              <p style="font-size: 12px; color: var(--text-muted);">
                Default Auditor Credentials: <code style="color: #fbbf24;">TPA</code> / <code style="color: #fbbf24;">TPA</code>
              </p>
            </div>

          </form>
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
