<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (request.getParameter("logout") != null) {
        try {
            session.invalidate();
        } catch (Exception ignored) {}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Fuzzy Identity-Based Data Integrity Auditing | Reliable Cloud Storage</title>
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
        <li class="active"><a href="index.jsp">Overview</a></li>
        <li><a href="User.jsp">User Portal</a></li>
        <li><a href="KGC.jsp">KGC Portal</a></li>
        <li><a href="TPA.jsp">TPA Portal</a></li>
        <li><a href="Cloud.jsp">Cloud Server</a></li>
      </ul>
    </div>
  </nav>

  <!-- Hero Section -->
  <main class="app-container hero-section">
    <div class="page-header-card">
      <div class="page-title-row">
        <div>
          <span class="role-badge kgc" style="margin-bottom: 12px;">VTU Major Project Phase II &bull; BCS786</span>
          <h2 class="page-title">Fuzzy Identity-Based Data Integrity Auditing for Reliable Cloud Storage</h2>
          <p class="page-subtitle">Biometric Identity Authentication &bull; Key-Insulated Cryptography &bull; Third-Party Auditing without Full Data Retrieval</p>
        </div>
        <div>
          <a href="User.jsp" class="btn btn-cyber">Get Started &rarr;</a>
        </div>
      </div>
    </div>

    <!-- 4-Entity Interactive Architecture Cards -->
    <div class="stats-grid" style="margin-top: 28px;">
      
      <!-- User Card -->
      <div class="stat-card" style="flex-direction: column; align-items: flex-start; cursor: pointer;" onclick="window.location.href='User.jsp'">
        <div style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
          <div class="stat-icon cyan">&#128100;</div>
          <span class="role-badge user">Data Owner</span>
        </div>
        <div class="stat-info" style="margin-top: 12px;">
          <h3 style="font-size: 18px;">User / Client</h3>
          <p style="margin-top: 4px; color: var(--text-secondary); text-transform: none; font-size: 13px;">
            Register with biometric signatures, encrypt files with AES-128, store in cloud, and dispatch auditing requests.
          </p>
        </div>
        <div style="margin-top: 16px; width: 100%;">
          <a href="User.jsp" class="btn btn-cyber btn-sm" style="width: 100%;">Access User Portal</a>
        </div>
      </div>

      <!-- KGC Card -->
      <div class="stat-card" style="flex-direction: column; align-items: flex-start; cursor: pointer;" onclick="window.location.href='KGC.jsp'">
        <div style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
          <div class="stat-icon purple">&#128273;</div>
          <span class="role-badge kgc">Key Authority</span>
        </div>
        <div class="stat-info" style="margin-top: 12px;">
          <h3 style="font-size: 18px;">Key Generation Center</h3>
          <p style="margin-top: 4px; color: var(--text-secondary); text-transform: none; font-size: 13px;">
            Verify biometric templates, approve registration requests, and issue Fuzzy Identity Private Keys.
          </p>
        </div>
        <div style="margin-top: 16px; width: 100%;">
          <a href="KGC.jsp" class="btn btn-outline btn-sm" style="width: 100%; border-color: rgba(139,92,246,0.4); color: var(--purple-glow);">Access KGC Portal</a>
        </div>
      </div>

      <!-- TPA Card -->
      <div class="stat-card" style="flex-direction: column; align-items: flex-start; cursor: pointer;" onclick="window.location.href='TPA.jsp'">
        <div style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
          <div class="stat-icon amber">&#128270;</div>
          <span class="role-badge tpa">Auditor</span>
        </div>
        <div class="stat-info" style="margin-top: 12px;">
          <h3 style="font-size: 18px;">Third Party Auditor</h3>
          <p style="margin-top: 4px; color: var(--text-secondary); text-transform: none; font-size: 13px;">
            Receive audit requests, challenge Cloud Storage, verify homomorphic proofs, and ensure data integrity.
          </p>
        </div>
        <div style="margin-top: 16px; width: 100%;">
          <a href="TPA.jsp" class="btn btn-outline btn-sm" style="width: 100%; border-color: rgba(245,158,11,0.4); color: #fbbf24;">Access TPA Portal</a>
        </div>
      </div>

      <!-- Cloud Card -->
      <div class="stat-card" style="flex-direction: column; align-items: flex-start; cursor: pointer;" onclick="window.location.href='Cloud.jsp'">
        <div style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
          <div class="stat-icon emerald">&#9729;</div>
          <span class="role-badge cloud">Cloud Server</span>
        </div>
        <div class="stat-info" style="margin-top: 12px;">
          <h3 style="font-size: 18px;">Cloud Service Provider</h3>
          <p style="margin-top: 4px; color: var(--text-secondary); text-transform: none; font-size: 13px;">
            Host encrypted ciphertexts, process audit challenges from TPA, and generate cryptographic integrity proofs.
          </p>
        </div>
        <div style="margin-top: 16px; width: 100%;">
          <a href="Cloud.jsp" class="btn btn-emerald btn-sm" style="width: 100%;">Access Cloud Server</a>
        </div>
      </div>

    </div>

    <!-- Auditing Lifecycle Workflow -->
    <div class="cyber-card" style="margin-top: 28px;">
      <div class="card-header">
        <h3>&#9889; System Architecture & Auditing Workflow</h3>
        <span class="role-badge user">End-to-End Pipeline</span>
      </div>
      <div class="card-body">
        <div class="workflow-pipeline" style="margin-bottom: 0;">
          <div class="pipeline-step done">
            <span class="step-num">1</span>
            <div>
              <div>Biometric Sign-up</div>
              <small style="color: var(--text-muted); font-size: 11px;">User &rarr; BLOB storage</small>
            </div>
          </div>
          <div class="pipeline-arrow">&rarr;</div>
          <div class="pipeline-step done">
            <span class="step-num">2</span>
            <div>
              <div>Fuzzy Key Gen</div>
              <small style="color: var(--text-muted); font-size: 11px;">KGC &rarr; Secret Key</small>
            </div>
          </div>
          <div class="pipeline-arrow">&rarr;</div>
          <div class="pipeline-step active">
            <span class="step-num">3</span>
            <div>
              <div>Upload & Encrypt</div>
              <small style="color: var(--text-muted); font-size: 11px;">AES-128 + SHA Hash</small>
            </div>
          </div>
          <div class="pipeline-arrow">&rarr;</div>
          <div class="pipeline-step active">
            <span class="step-num">4</span>
            <div>
              <div>Audit Challenge</div>
              <small style="color: var(--text-muted); font-size: 11px;">User &rarr; TPA &rarr; Cloud</small>
            </div>
          </div>
          <div class="pipeline-arrow">&rarr;</div>
          <div class="pipeline-step active">
            <span class="step-num">5</span>
            <div>
              <div>Proof Verification</div>
              <small style="color: var(--text-muted); font-size: 11px;">Integrity Guaranteed</small>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>

  <!-- Footer -->
  <footer class="cyber-footer">
    <div class="app-container">
      <p><strong>Department of Computer Science & Engineering</strong> &bull; R R Institute of Technology</p>
      <div class="footer-credits">
        <span class="team-pill">Kiran B C (1RI23CS067)</span>
        <span class="team-pill">Kishor K (1RI23CS068)</span>
        <span class="team-pill">Chandan Malik (1RI23CS028)</span>
        <span class="team-pill">Anil Kumar Parida (1RI23CS009)</span>
        <span class="team-pill" style="border-color: var(--cyan-primary); color: var(--cyan-glow);">Guide: Prof. Prashanthkumar L</span>
      </div>
    </div>
  </footer>

</body>
</html>
