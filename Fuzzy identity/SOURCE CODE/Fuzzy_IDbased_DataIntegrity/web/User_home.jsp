<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String uname = (String)session.getAttribute("uname");
    String umail = (String)session.getAttribute("umail");
    String uid = (String)session.getAttribute("uid");
    if (uname == null) {
        uname = "Data Owner";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Dashboard | Fuzzy Identity-Based Auditing</title>
  <link rel="stylesheet" href="css/cyber_theme.css">
</head>
<body>

  <!-- Top Navigation Bar -->
  <nav class="cyber-navbar">
    <div class="app-container nav-wrapper">
      <a href="User_home.jsp" class="brand-logo">
        <div class="brand-icon">U</div>
        <div class="brand-text">
          <h1>USER DASHBOARD</h1>
          <p><%= uname %> &bull; Authenticated</p>
        </div>
      </a>
      <ul class="nav-links">
        <li class="active"><a href="User_home.jsp">Dashboard</a></li>
        <li><a href="File_Upload.jsp">Upload File</a></li>
        <li><a href="MyFiles.jsp">My Files</a></li>
        <li><a href="audit_request.jsp">Request Audit</a></li>
        <li><a href="user_check.jsp">Audit Proofs</a></li>
        <li><a href="index.jsp" style="color: var(--rose-primary);">Logout</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div class="page-header-card">
      <div class="page-title-row">
        <div>
          <span class="role-badge user" style="margin-bottom: 10px;">Authenticated Data Owner</span>
          <h2 class="page-title">Welcome back, <%= uname %>!</h2>
          <p class="page-subtitle">User ID: <span style="font-family: var(--font-mono); color: var(--cyan-glow);"><%= uid != null ? uid : "N/A" %></span> &bull; Email: <span style="font-family: var(--font-mono);"><%= umail != null ? umail : "N/A" %></span></p>
        </div>
        <div>
          <a href="File_Upload.jsp" class="btn btn-cyber">&#43; Upload & Encrypt New File</a>
        </div>
      </div>
    </div>

    <!-- Quick Stats -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon cyan">&#128196;</div>
        <div class="stat-info">
          <p>Storage Action</p>
          <h3 style="font-size: 16px;"><a href="File_Upload.jsp" style="color: white; text-decoration: none;">AES-128 Encryption</a></h3>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon purple">&#128451;</div>
        <div class="stat-info">
          <p>Repository</p>
          <h3 style="font-size: 16px;"><a href="MyFiles.jsp" style="color: white; text-decoration: none;">View Stored Files</a></h3>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon amber">&#128270;</div>
        <div class="stat-info">
          <p>Integrity Audit</p>
          <h3 style="font-size: 16px;"><a href="audit_request.jsp" style="color: white; text-decoration: none;">Challenge TPA</a></h3>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon emerald">&#9989;</div>
        <div class="stat-info">
          <p>Proof Verification</p>
          <h3 style="font-size: 16px;"><a href="user_check.jsp" style="color: white; text-decoration: none;">View Audit Results</a></h3>
        </div>
      </div>
    </div>

    <!-- Auditing Lifecycle Workflow -->
    <div class="cyber-card">
      <div class="card-header">
        <h3>&#128202; Data Owner Auditing Workflow</h3>
        <span class="role-badge user">Active Session</span>
      </div>
      <div class="card-body">
        <div class="workflow-pipeline" style="margin-bottom: 0;">
          <div class="pipeline-step done">
            <span class="step-num">&#10003;</span>
            <div>
              <div>Biometric Identity</div>
              <small style="color: var(--text-muted); font-size: 11px;">Verified by KGC</small>
            </div>
          </div>
          <div class="pipeline-arrow">&rarr;</div>
          <div class="pipeline-step active">
            <span class="step-num">1</span>
            <div>
              <div>Upload & Encrypt</div>
              <small style="color: var(--text-muted); font-size: 11px;">AES ciphertext + Hash</small>
            </div>
          </div>
          <div class="pipeline-arrow">&rarr;</div>
          <div class="pipeline-step active">
            <span class="step-num">2</span>
            <div>
              <div>Send Audit Challenge</div>
              <small style="color: var(--text-muted); font-size: 11px;">Trigger TPA verification</small>
            </div>
          </div>
          <div class="pipeline-arrow">&rarr;</div>
          <div class="pipeline-step active">
            <span class="step-num">3</span>
            <div>
              <div>Check Integrity Proof</div>
              <small style="color: var(--text-muted); font-size: 11px;">Deterministic comparison</small>
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
    </div>
  </footer>

</body>
</html>
