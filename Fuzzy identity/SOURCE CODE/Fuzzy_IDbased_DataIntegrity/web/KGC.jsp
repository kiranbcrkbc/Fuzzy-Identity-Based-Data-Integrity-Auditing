<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>KGC Login | Key Generation Center</title>
  <link rel="stylesheet" href="css/cyber_theme.css">
</head>
<body>

  <!-- Top Navigation Bar -->
  <nav class="cyber-navbar">
    <div class="app-container nav-wrapper">
      <a href="index.jsp" class="brand-logo">
        <div class="brand-icon" style="background: linear-gradient(135deg, var(--purple-primary), var(--cyan-primary));">K</div>
        <div class="brand-text">
          <h1>KEY GENERATION CENTER</h1>
          <p>Cryptographic Authority</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="User.jsp">User Portal</a></li>
        <li class="active"><a href="KGC.jsp">KGC Portal</a></li>
        <li><a href="TPA.jsp">TPA Portal</a></li>
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
          <div><strong>Invalid Credentials:</strong> Please verify KGC username and master password.</div>
        </div>
      <% } %>

      <div class="cyber-card">
        <div class="card-header">
          <h3>&#128273; Key Generation Center Authority</h3>
          <span class="role-badge kgc">KGC Admin</span>
        </div>
        <div class="card-body">
          <form action="KGC" method="post">
            
            <div class="form-group">
              <label for="kgcid">KGC Authority ID / Username</label>
              <input id="kgcid" type="text" name="kgcid" class="form-control" placeholder="Enter KGC ID (Default: kgc)" required autocomplete="username">
            </div>

            <div class="form-group">
              <label for="password">Master Password</label>
              <input id="password" type="password" name="password" class="form-control" placeholder="Enter master password (Default: kgc)" required autocomplete="current-password">
            </div>

            <div style="margin-top: 24px;">
              <button type="submit" class="btn btn-cyber" style="width: 100%; background: linear-gradient(135deg, var(--purple-primary), #6366f1); color: white;">
                Authenticate KGC Authority &rarr;
              </button>
            </div>

            <div style="margin-top: 20px; text-align: center; border-top: 1px solid var(--border-color); padding-top: 16px;">
              <p style="font-size: 12px; color: var(--text-muted);">
                Default Master Credentials: <code style="color: var(--purple-glow);">kgc</code> / <code style="color: var(--purple-glow);">kgc</code> (or <code style="color: var(--purple-glow);">admin</code>)
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
