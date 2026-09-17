<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Key Dispatched | KGC Authority</title>
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
          <p>Key Generation Center</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="KGC_home.jsp">Dashboard</a></li>
        <li><a href="keyreq.jsp">Key Generation Requests</a></li>
        <li><a href="kgc_users.jsp">Registered Users</a></li>
        <li><a href="index.jsp" style="color: var(--rose-primary);">Logout</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div style="max-width: 540px; margin: 40px auto;">

      <div class="alert-banner success">
        <span>&#10004;</span>
        <div><strong>Key Successfully Generated & Issued!</strong> The Fuzzy Identity-Based Private Key has been recorded in the database and dispatched to the Data Owner.</div>
      </div>

      <div class="cyber-card" style="text-align: center; padding: 20px;">
        <div class="stat-icon purple" style="margin: 0 auto 16px; width: 64px; height: 64px; font-size: 32px;">&#128273;</div>
        <h3 style="font-size: 20px; color: white;">Identity Key Generated</h3>
        <p style="color: var(--text-secondary); font-size: 13px; margin: 8px 0 24px;">
          The user can now authenticate and perform AES-128 file encryption with their issued identity credentials.
        </p>
        <div style="display: flex; gap: 12px; justify-content: center;">
          <a href="keyreq.jsp" class="btn btn-cyber">Review More Requests &rarr;</a>
          <a href="KGC_home.jsp" class="btn btn-outline">Return to Dashboard</a>
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
