<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cloud Server Login | Cloud Storage Provider</title>
  <link rel="stylesheet" href="css/cyber_theme.css">
</head>
<body>

  <!-- Top Navigation Bar -->
  <nav class="cyber-navbar">
    <div class="app-container nav-wrapper">
      <a href="index.jsp" class="brand-logo">
        <div class="brand-icon" style="background: linear-gradient(135deg, var(--emerald-primary), #059669);">&#9729;</div>
        <div class="brand-text">
          <h1>CLOUD SERVICE PROVIDER</h1>
          <p>Storage & Proof Computation</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="User.jsp">User Portal</a></li>
        <li><a href="KGC.jsp">KGC Portal</a></li>
        <li><a href="TPA.jsp">TPA Portal</a></li>
        <li class="active"><a href="Cloud.jsp">Cloud Server</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div style="max-width: 480px; margin: 40px auto;">

      <% if (request.getParameter("failed") != null) { %>
        <div class="alert-banner error">
          <span>&#9888;</span>
          <div><strong>Authentication Failed:</strong> Please verify Cloud Server credentials.</div>
        </div>
      <% } %>

      <div class="cyber-card">
        <div class="card-header">
          <h3>&#9729; Cloud Storage Provider Login</h3>
          <span class="role-badge cloud">CSP Server</span>
        </div>
        <div class="card-body">
          <form action="clloud" method="post">
            
            <div class="form-group">
              <label for="cloud">Cloud Server Account / ID</label>
              <input id="cloud" type="text" name="cloud" class="form-control" placeholder="Enter Cloud ID (Default: cloud)" required autocomplete="username">
            </div>

            <div class="form-group">
              <label for="password">Server Access Key / Password</label>
              <input id="password" type="password" name="password" class="form-control" placeholder="Enter cloud password (Default: cloud)" required autocomplete="current-password">
            </div>

            <div style="margin-top: 24px;">
              <button type="submit" class="btn btn-emerald" style="width: 100%; font-size: 15px;">
                Authenticate Cloud Server &rarr;
              </button>
            </div>

            <div style="margin-top: 20px; text-align: center; border-top: 1px solid var(--border-color); padding-top: 16px;">
              <p style="font-size: 12px; color: var(--text-muted);">
                Default Cloud Credentials: <code style="color: var(--emerald-glow);">cloud</code> / <code style="color: var(--emerald-glow);">cloud</code>
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
