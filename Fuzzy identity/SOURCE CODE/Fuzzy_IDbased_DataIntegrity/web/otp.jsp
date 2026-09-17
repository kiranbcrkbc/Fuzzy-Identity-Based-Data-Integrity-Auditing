<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>OTP Verification | Fuzzy Identity-Based Auditing</title>
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
    <div style="max-width: 440px; margin: 40px auto;">

      <% if (request.getParameter("Msg") != null && request.getParameter("Msg").contains("Wrong_OTP")) { %>
        <div class="alert-banner error">
          <span>&#9888;</span>
          <div><strong>Incorrect OTP:</strong> The one-time password entered did not match our records. Please try again.</div>
        </div>
      <% } else { %>
        <div class="alert-banner info">
          <span>&#128272;</span>
          <div><strong>OTP Dispatched:</strong> A one-time dynamic verification challenge has been generated for your session.</div>
        </div>
      <% } %>

      <div class="cyber-card">
        <div class="card-header">
          <h3>&#128274; Two-Factor OTP Challenge</h3>
          <span class="role-badge user">Step 2 of 2</span>
        </div>
        <div class="card-body">
          <form action="otp1.jsp" method="get">
            
            <div class="form-group">
              <label for="votp">Enter 6-Digit One-Time Password</label>
              <input id="votp" type="text" name="votp" class="form-control" placeholder="e.g. I12345" required style="font-family: var(--font-mono); letter-spacing: 0.2em; font-size: 18px; text-align: center;" autofocus>
              <small style="color: var(--text-muted); font-size: 12px; margin-top: 4px;">Check your email or server log console for the OTP code.</small>
            </div>

            <div style="margin-top: 24px;">
              <button type="submit" class="btn btn-cyber" style="width: 100%;">Verify OTP & Enter Dashboard &rarr;</button>
            </div>

            <div style="margin-top: 16px; text-align: center;">
              <a href="User.jsp" style="color: var(--text-secondary); font-size: 12px; text-decoration: none;">&larr; Back to Login</a>
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
