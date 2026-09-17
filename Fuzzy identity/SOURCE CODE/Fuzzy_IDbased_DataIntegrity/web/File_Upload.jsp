<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String uname = (String)session.getAttribute("uname");
    if (uname == null) {
        uname = "Data Owner";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>File Upload & AES Encryption | Fuzzy Identity Auditing</title>
  <link rel="stylesheet" href="css/cyber_theme.css">
  <script>
    function updateFileName(input) {
      if (input.files && input.files[0]) {
        var file = input.files[0];
        document.getElementById('file-chosen-name').innerText = file.name + ' (' + (file.size / 1024).toFixed(2) + ' KB)';
        if (!document.getElementById('fname').value) {
          document.getElementById('fname').value = file.name.split('.')[0];
        }
      }
    }
  </script>
</head>
<body>

  <!-- Top Navigation Bar -->
  <nav class="cyber-navbar">
    <div class="app-container nav-wrapper">
      <a href="User_home.jsp" class="brand-logo">
        <div class="brand-icon">U</div>
        <div class="brand-text">
          <h1>USER PORTAL</h1>
          <p><%= uname %> &bull; File Upload</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="User_home.jsp">Dashboard</a></li>
        <li class="active"><a href="File_Upload.jsp">Upload File</a></li>
        <li><a href="MyFiles.jsp">My Files</a></li>
        <li><a href="audit_request.jsp">Request Audit</a></li>
        <li><a href="user_check.jsp">Audit Proofs</a></li>
        <li><a href="index.jsp" style="color: var(--rose-primary);">Logout</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div style="max-width: 640px; margin: 20px auto;">

      <% if (request.getParameter("Successful") != null) { %>
        <div class="alert-banner success">
          <span>&#10004;</span>
          <div><strong>Upload & Encryption Successful!</strong> File encrypted via AES-128, hash code generated, and stored in secure repository.</div>
        </div>
      <% } %>

      <% if (request.getParameter("failed") != null) { %>
        <div class="alert-banner error">
          <span>&#9888;</span>
          <div><strong>Upload Failed:</strong> Please select a valid file to upload.</div>
        </div>
      <% } %>

      <div class="cyber-card">
        <div class="card-header">
          <h3>&#128274; Upload & Encrypt Cloud Document</h3>
          <span class="role-badge user">AES-128 GCM</span>
        </div>
        <div class="card-body">
          <form action="Upload" method="post" enctype="multipart/form-data">
            
            <div class="form-group">
              <label for="fname">Document Title / Tag *</label>
              <input id="fname" type="text" name="fname" class="form-control" placeholder="e.g. Financial_Report_2026" required>
              <small style="color: var(--text-muted); font-size: 12px;">Descriptive identifier for data indexing.</small>
            </div>

            <div class="form-group">
              <label for="file-upload">Select File to Encrypt & Store *</label>
              <div class="file-dropzone" onclick="document.getElementById('file-upload').click();">
                <div class="dropzone-icon">&#128194;</div>
                <div style="font-size: 15px; font-weight: 600; color: white;">Click to browse or drop file here</div>
                <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Supports all text, documents, code, logs, and datasets</div>
                <input id="file-upload" type="file" name="data" style="display: none;" onchange="updateFileName(this);" required>
                <div id="file-chosen-name" style="margin-top: 12px; font-size: 13px; color: var(--cyan-glow); font-family: var(--font-mono); font-weight: 500;">No file selected</div>
              </div>
            </div>

            <!-- Cryptographic Guarantee Info -->
            <div style="background: rgba(15, 23, 42, 0.6); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 14px; margin: 20px 0; font-size: 12px; color: var(--text-secondary);">
              <div style="font-weight: 600; color: var(--cyan-glow); margin-bottom: 4px;">&#9889; Automated Cryptographic Pipeline:</div>
              <ul style="padding-left: 18px; line-height: 1.6;">
                <li>Content is automatically encrypted with dynamic AES secret key.</li>
                <li>Deterministic integrity hash code is computed prior to cloud transmission.</li>
                <li>Key-Insulated auditing signature is indexed for third-party verification.</li>
              </ul>
            </div>

            <div>
              <button type="submit" class="btn btn-cyber" style="width: 100%; font-size: 15px;">Encrypt & Store in Cloud &rarr;</button>
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
