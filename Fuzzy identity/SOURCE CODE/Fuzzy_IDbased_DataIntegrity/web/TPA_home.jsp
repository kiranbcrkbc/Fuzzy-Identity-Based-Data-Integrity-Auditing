<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TPA Dashboard | Third Party Auditor</title>
  <link rel="stylesheet" href="css/cyber_theme.css">
</head>
<body>

  <!-- Top Navigation Bar -->
  <nav class="cyber-navbar">
    <div class="app-container nav-wrapper">
      <a href="TPA_home.jsp" class="brand-logo">
        <div class="brand-icon" style="background: linear-gradient(135deg, var(--amber-primary), #d97706);">T</div>
        <div class="brand-text">
          <h1>TPA AUDITING SUITE</h1>
          <p>Third Party Auditor &bull; Active</p>
        </div>
      </a>
      <ul class="nav-links">
        <li class="active"><a href="TPA_home.jsp">Dashboard</a></li>
        <li><a href="TPA_audit_request.jsp">User Audit Requests</a></li>
        <li><a href="cloud_req.jsp">Cloud Challenges</a></li>
        <li><a href="proof_Check.jsp">Auditing Proofs</a></li>
        <li><a href="index.jsp" style="color: var(--rose-primary);">Logout</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div class="page-header-card">
      <div class="page-title-row">
        <div>
          <span class="role-badge tpa" style="margin-bottom: 10px;">Public Data Auditor</span>
          <h2 class="page-title">Third Party Auditor Control Center</h2>
          <p class="page-subtitle">Verify data integrity challenges without downloading full files, maintaining zero-knowledge data privacy.</p>
        </div>
        <div>
          <a href="TPA_audit_request.jsp" class="btn btn-cyber" style="background: linear-gradient(135deg, var(--amber-primary), #d97706); color: #0b0f19; font-weight: 700;">
            &#128270; Process User Requests &rarr;
          </a>
        </div>
      </div>
    </div>

    <!-- Quick Stats -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon amber">&#128233;</div>
        <div class="stat-info">
          <p>Pending Challenges</p>
          <h3 style="font-size: 16px;"><a href="TPA_audit_request.jsp" style="color: white; text-decoration: none;">Review Audit Requests</a></h3>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon cyan">&#9729;</div>
        <div class="stat-info">
          <p>Cloud Transmission</p>
          <h3 style="font-size: 16px;"><a href="cloud_req.jsp" style="color: white; text-decoration: none;">Track Cloud Requests</a></h3>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon emerald">&#9989;</div>
        <div class="stat-info">
          <p>Integrity Validation</p>
          <h3 style="font-size: 16px;"><a href="proof_Check.jsp" style="color: white; text-decoration: none;">Audit Proof Records</a></h3>
        </div>
      </div>
    </div>

    <!-- TPA Protocol Principles Card -->
    <div class="cyber-card">
      <div class="card-header">
        <h3>&#128737; Privacy-Preserving Public Auditing Principles</h3>
        <span class="role-badge tpa">Zero-Knowledge</span>
      </div>
      <div class="card-body">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; font-size: 13px;">
          <div style="background: rgba(15, 23, 42, 0.6); padding: 18px; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
            <div style="font-weight: 700; color: #fbbf24; margin-bottom: 6px;">1. Public Verifiability</div>
            <p style="color: var(--text-secondary); line-height: 1.6;">Enables TPA to audit correctness on behalf of data owners without requiring data owner online presence.</p>
          </div>
          <div style="background: rgba(15, 23, 42, 0.6); padding: 18px; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
            <div style="font-weight: 700; color: var(--cyan-glow); margin-bottom: 6px;">2. Privacy-Preserving Verification</div>
            <p style="color: var(--text-secondary); line-height: 1.6;">Audits homomorphic hash tags so that TPA learns zero information about original plaintexts.</p>
          </div>
          <div style="background: rgba(15, 23, 42, 0.6); padding: 18px; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
            <div style="font-weight: 700; color: var(--emerald-glow); margin-bottom: 6px;">3. Key-Insulation & Lightweight</div>
            <p style="color: var(--text-secondary); line-height: 1.6;">Protects against secret key exposure across discrete auditing periods while keeping computation overhead minimal.</p>
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
