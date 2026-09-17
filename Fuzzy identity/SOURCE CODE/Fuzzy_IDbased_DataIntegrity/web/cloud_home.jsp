<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cloud Server Dashboard | Cloud Service Provider</title>
  <link rel="stylesheet" href="css/cyber_theme.css">
</head>
<body>

  <!-- Top Navigation Bar -->
  <nav class="cyber-navbar">
    <div class="app-container nav-wrapper">
      <a href="cloud_home.jsp" class="brand-logo">
        <div class="brand-icon" style="background: linear-gradient(135deg, var(--emerald-primary), #059669);">&#9729;</div>
        <div class="brand-text">
          <h1>CLOUD SERVICE PROVIDER</h1>
          <p>Storage & Proof Processing Server</p>
        </div>
      </a>
      <ul class="nav-links">
        <li class="active"><a href="cloud_home.jsp">Dashboard</a></li>
        <li><a href="cloud_audit.jsp">Process Audits & Proofs</a></li>
        <li><a href="All_files.jsp">Stored Files in Cloud</a></li>
        <li><a href="index.jsp" style="color: var(--rose-primary);">Logout</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div class="page-header-card">
      <div class="page-title-row">
        <div>
          <span class="role-badge cloud" style="margin-bottom: 10px;">Cloud Service Provider</span>
          <h2 class="page-title">Cloud Storage Operations Center</h2>
          <p class="page-subtitle">Host encrypted client ciphertexts, respond to TPA auditing challenges, and compute cryptographic integrity proofs.</p>
        </div>
        <div>
          <a href="cloud_audit.jsp" class="btn btn-emerald">
            &#9889; Process Audit Challenges &rarr;
          </a>
        </div>
      </div>
    </div>

    <!-- Quick Stats -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon emerald">&#9729;</div>
        <div class="stat-info">
          <p>Cloud Storage</p>
          <h3 style="font-size: 16px;"><a href="All_files.jsp" style="color: white; text-decoration: none;">View All Files in Cloud</a></h3>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon amber">&#9889;</div>
        <div class="stat-info">
          <p>Proof Computation</p>
          <h3 style="font-size: 16px;"><a href="cloud_audit.jsp" style="color: white; text-decoration: none;">Respond to TPA Audits</a></h3>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon cyan">&#128274;</div>
        <div class="stat-info">
          <p>Security Status</p>
          <h3 style="font-size: 16px; color: var(--cyan-glow);">AES-128 Encrypted</h3>
        </div>
      </div>
    </div>

    <!-- Cloud Service Architecture -->
    <div class="cyber-card">
      <div class="card-header">
        <h3>&#128187; Cloud Server Operational Modules</h3>
        <span class="role-badge cloud">System Online</span>
      </div>
      <div class="card-body">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; font-size: 13px;">
          <div style="background: rgba(15, 23, 42, 0.6); padding: 18px; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
            <div style="font-weight: 700; color: var(--emerald-glow); margin-bottom: 6px;">1. Encrypted Blob Storage</div>
            <p style="color: var(--text-secondary); line-height: 1.6;">Maintains encrypted user data blocks with zero unauthorized decryption exposure or plain text leaks.</p>
          </div>
          <div style="background: rgba(15, 23, 42, 0.6); padding: 18px; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
            <div style="font-weight: 700; color: #fbbf24; margin-bottom: 6px;">2. Challenge Reception</div>
            <p style="color: var(--text-secondary); line-height: 1.6;">Accepts sampling audit queries dispatched by TPA without revealing file contents to untrusted parties.</p>
          </div>
          <div style="background: rgba(15, 23, 42, 0.6); padding: 18px; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
            <div style="font-weight: 700; color: var(--cyan-glow); margin-bottom: 6px;">3. Homomorphic Proof Generation</div>
            <p style="color: var(--text-secondary); line-height: 1.6;">Aggregates queried data blocks into a compact cryptographic proof hash returned directly to the auditing pipeline.</p>
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
