<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Login | Fuzzy Identity-Based Auditing</title>
  <link rel="stylesheet" href="css/cyber_theme.css">
</head>
<body>

  <!-- Top Navigation Bar -->
  <nav class="cyber-navbar">
    <div class="app-container nav-wrapper">
      <a href="index.jsp" class="brand-logo">
        <div class="brand-icon">F</div>
        <div class="brand-text">
          <h1>FUZZY IDENTITY-BASED AUDITING</h1>
          <p>Reliable Cloud Storage System</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="index.jsp">Home</a></li>
        <li class="active"><a href="User.jsp">User Portal</a></li>
        <li><a href="KGC.jsp">KGC Portal</a></li>
        <li><a href="TPA.jsp">TPA Portal</a></li>
        <li><a href="Cloud.jsp">Cloud Server</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div style="max-width: 480px; margin: 40px auto;">

      <% if (request.getParameter("Successful") != null) { %>
        <div class="alert-banner success">
          <span>&#10004;</span>
          <div><strong>Registration Successful!</strong> Your biometric identity has been recorded. Please wait for KGC key generation before logging in.</div>
        </div>
      <% } %>

      <% if (request.getParameter("Msg") != null && request.getParameter("Msg").contains("Pending_KGC_Approval")) { %>
        <div class="alert-banner info">
          <span>&#128273;</span>
          <div><strong>Pending KGC Key Generation:</strong> Your identity registration is recorded, but KGC has not yet issued your private key. Please authenticate as KGC to issue keys.</div>
        </div>
      <% } else if (request.getParameter("Msg") != null && request.getParameter("Msg").contains("Authentication_Failed")) { %>
        <div class="alert-banner error">
          <span>&#9888;</span>
          <div><strong>Authentication Failed:</strong> Invalid email or password. Please verify your credentials and try again.</div>
        </div>
      <% } else if (request.getParameter("Msg") != null && request.getParameter("Msg").contains("Session_Expired")) { %>
        <div class="alert-banner info">
          <span>&#8987;</span>
          <div><strong>Session Expired:</strong> Your session has expired or you are not logged in. Please authenticate below.</div>
        </div>
      <% } %>

      <div class="cyber-card">
        <div class="card-header">
          <h3>&#128100; Data Owner / User Login</h3>
          <span class="role-badge user">Client</span>
        </div>
        <div class="card-body">
          <form action="user_login.jsp" method="post">
            <div class="form-group">
              <label for="email">User Email Address</label>
              <input id="email" type="email" name="email" class="form-control" placeholder="e.g. kiran@example.com" required autocomplete="email">
            </div>

            <div class="form-group">
              <label for="pass">Password</label>
              <input id="pass" type="password" name="pass" class="form-control" placeholder="Enter your secret password" required autocomplete="current-password">
            </div>

            <div style="margin-top: 24px;">
              <button type="submit" class="btn btn-cyber" style="width: 100%;">Authenticate & Request OTP &rarr;</button>
            </div>

            <div style="margin-top: 20px; text-align: center; border-top: 1px solid var(--border-color); padding-top: 16px;">
              <p style="font-size: 13px; color: var(--text-secondary);">
                Don't have an account? 
                <a href="User_reg.jsp" style="color: var(--cyan-glow); font-weight: 600; text-decoration: none;">Register with Biometrics &rarr;</a>
              </p>
            </div>
          </form>
        </div>
      </div>

      <!-- Quick Helper Note -->
      <div style="text-align: center; font-size: 12px; color: var(--text-muted);">
        <p>&#128274; Secured via Fuzzy Identity-Based Key-Insulated Verification</p>
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
