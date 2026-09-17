<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Proof Operations | Fuzzy Identity Auditing</title>
  <link rel="stylesheet" href="css/cyber_theme.css">
</head>
<body>

  <!-- Top Navigation Bar -->
  <nav class="cyber-navbar">
    <div class="app-container nav-wrapper">
      <a href="cloud_home.jsp" class="brand-logo">
        <div class="brand-icon" style="background: linear-gradient(135deg, var(--emerald-primary), var(--cyan-primary));">&#9729;</div>
        <div class="brand-text">
          <h1>CLOUD STORAGE & AUDIT</h1>
          <p>Proof Verification Center</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="cloud_home.jsp">Cloud Dashboard</a></li>
        <li><a href="cloud_audit.jsp">Audit Challenges</a></li>
        <li><a href="All_files.jsp">Stored Files</a></li>
        <li><a href="index.jsp" style="color: var(--rose-primary);">Logout</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div class="page-header-card">
      <div class="page-title-row">
        <div>
          <span class="role-badge cloud" style="margin-bottom: 10px;">Cloud Cryptographic Operations</span>
          <h2 class="page-title">Proof Operations & Audit Routing</h2>
          <p class="page-subtitle">Homomorphic proof generation and auditing verification for stored ciphertext blocks.</p>
        </div>
      </div>
    </div>

    <div class="stats-grid" style="margin-top: 24px;">
      <div class="stat-card" style="cursor: pointer;" onclick="window.location.href='cloud_audit.jsp'">
        <div class="stat-icon emerald">&#9889;</div>
        <div class="stat-info">
          <p>Pending Challenges</p>
          <h3 style="font-size: 16px;"><a href="cloud_audit.jsp" style="color: white; text-decoration: none;">Compute & Send Proofs &rarr;</a></h3>
        </div>
      </div>
      <div class="stat-card" style="cursor: pointer;" onclick="window.location.href='All_files.jsp'">
        <div class="stat-icon cyan">&#128194;</div>
        <div class="stat-info">
          <p>Cloud Storage</p>
          <h3 style="font-size: 16px;"><a href="All_files.jsp" style="color: white; text-decoration: none;">View All Files in Cloud &rarr;</a></h3>
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
