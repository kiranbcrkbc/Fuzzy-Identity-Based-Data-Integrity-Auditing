<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>KGC Dashboard | Key Generation Center</title>
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
          <p>Key Generation Center &bull; Administrator</p>
        </div>
      </a>
      <ul class="nav-links">
        <li class="active"><a href="KGC_home.jsp">Dashboard</a></li>
        <li><a href="keyreq.jsp">Key Generation Requests</a></li>
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
          <span class="role-badge kgc" style="margin-bottom: 10px;">Master Cryptographic Authority</span>
          <h2 class="page-title">Key Generation Center Dashboard</h2>
          <p class="page-subtitle">Manage biometric identity registrations, verify biometric signatures, and issue Fuzzy Identity Private Keys.</p>
        </div>
        <div>
          <a href="keyreq.jsp" class="btn btn-cyber" style="background: linear-gradient(135deg, var(--purple-primary), #6366f1); color: white;">
            &#128273; Review Key Requests &rarr;
          </a>
        </div>
      </div>
    </div>

    <!-- Quick Stats -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon purple">&#128101;</div>
        <div class="stat-info">
          <p>User Management</p>
          <h3 style="font-size: 16px;"><a href="kgc_users.jsp" style="color: white; text-decoration: none;">View Registered Users</a></h3>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon amber">&#9997;</div>
        <div class="stat-info">
          <p>Biometric Templates</p>
          <h3 style="font-size: 16px;"><a href="kgc_users.jsp" style="color: white; text-decoration: none;">Inspect Signature BLOBs</a></h3>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon cyan">&#128273;</div>
        <div class="stat-info">
          <p>Key Generation</p>
          <h3 style="font-size: 16px;"><a href="keyreq.jsp" style="color: white; text-decoration: none;">Pending Authorizations</a></h3>
        </div>
      </div>
    </div>

    <!-- KGC Authority Role Card -->
    <div class="cyber-card">
      <div class="card-header">
        <h3>&#128272; Fuzzy Identity Cryptographic Responsibilities</h3>
        <span class="role-badge kgc">Active Authority</span>
      </div>
      <div class="card-body">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; font-size: 13px;">
          <div style="background: rgba(15, 23, 42, 0.6); padding: 18px; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
            <div style="font-weight: 700; color: var(--purple-glow); margin-bottom: 6px;">1. Biometric Feature Extraction</div>
            <p style="color: var(--text-secondary); line-height: 1.6;">Extracts fuzzy biometric characteristics from uploaded signature templates and binds identity strings into private keys.</p>
          </div>
          <div style="background: rgba(15, 23, 42, 0.6); padding: 18px; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
            <div style="font-weight: 700; color: var(--cyan-glow); margin-bottom: 6px;">2. Master Key Pair Generation</div>
            <p style="color: var(--text-secondary); line-height: 1.6;">Maintains master public/secret parameters and derives identity-based keys without escrow vulnerabilities.</p>
          </div>
          <div style="background: rgba(15, 23, 42, 0.6); padding: 18px; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
            <div style="font-weight: 700; color: var(--emerald-glow); margin-bottom: 6px;">3. Secure Key Delivery</div>
            <p style="color: var(--text-secondary); line-height: 1.6;">Transmits derived private keys to authorized Data Owners for data encryption and auditing tag computation.</p>
          </div>
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
