<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Registration | Biometric Identity Sign-up</title>
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
    <div style="max-width: 680px; margin: 20px auto;">

      <% 
         String failedReason = request.getParameter("failed");
         if (failedReason != null) { 
           String msgText = "Please verify all required fields and try again.";
           if (failedReason.contains("duplicate")) {
             msgText = "An account with this email address is already registered. Please log in instead.";
           } else if (failedReason.contains("password_mismatch")) {
             msgText = "Passwords do not match. Please ensure both passwords match exactly.";
           } else if (failedReason.contains("missing_fields")) {
             msgText = "Please fill in all mandatory fields.";
           } else if (failedReason.contains("db_error")) {
             msgText = "Database connection error. Please verify MySQL service.";
           }
      %>
        <div class="alert-banner error">
          <span>&#9888;</span>
          <div><strong>Registration Failed:</strong> <%= msgText %></div>
        </div>
      <% } %>

      <div class="cyber-card">
        <div class="card-header">
          <h3>&#128101; Biometric Identity Registration</h3>
          <span class="role-badge user">New Client</span>
        </div>
        <div class="card-body">
          <form action="signup" method="post" enctype="multipart/form-data">
            
            <div class="form-grid">
              <div class="form-group">
                <label for="name">Full Name *</label>
                <input id="name" type="text" name="name" class="form-control" placeholder="e.g. Kiran B C" required>
              </div>

              <div class="form-group">
                <label for="email">Email Address *</label>
                <input id="email" type="email" name="email" class="form-control" placeholder="e.g. kiran@example.com" required>
              </div>

              <div class="form-group">
                <label for="phone">Phone Number *</label>
                <input id="phone" type="tel" name="phone" class="form-control" placeholder="e.g. 9876543210" required>
              </div>

              <div class="form-group">
                <label for="dob">Date of Birth *</label>
                <input id="dob" type="date" name="dob" class="form-control" required>
              </div>

              <div class="form-group">
                <label for="gender">Gender *</label>
                <select id="gender" name="gender" class="form-control" required>
                  <option value="">Select Gender</option>
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                  <option value="Others">Others</option>
                </select>
              </div>

              <div class="form-group">
                <label for="city">City</label>
                <input id="city" type="text" name="city" class="form-control" placeholder="e.g. Bangalore">
              </div>

              <div class="form-group">
                <label for="country">Country</label>
                <input id="country" type="text" name="country" class="form-control" placeholder="e.g. India">
              </div>

              <div class="form-group">
                <label for="password">Password *</label>
                <input id="password" type="password" name="password" class="form-control" placeholder="Create password" required>
              </div>

              <div class="form-group">
                <label for="rpassword">Confirm Password *</label>
                <input id="rpassword" type="password" name="rpassword" class="form-control" placeholder="Repeat password" required>
              </div>
            </div>

            <!-- Biometric Signature Upload Dropzone -->
            <div class="form-group" style="margin-top: 16px;">
              <label for="bio_sign">Biometric Signature Template (Image/PNG/JPG) *</label>
              <div class="file-dropzone" onclick="document.getElementById('bio_sign').click();">
                <div class="dropzone-icon">&#9997;</div>
                <div style="font-size: 14px; font-weight: 600; color: white;">Click to select Biometric Signature</div>
                <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Supports PNG, JPG, GIF biometric fingerprint or hand signature</div>
                <input id="bio_sign" type="file" name="bio_sign" style="display: none;" onchange="document.getElementById('sign-chosen').innerText = this.files[0] ? this.files[0].name : 'No file chosen';">
                <div id="sign-chosen" style="margin-top: 10px; font-size: 12px; color: var(--cyan-glow); font-family: var(--font-mono);">No file selected yet</div>
              </div>
            </div>

            <div style="margin-top: 28px;">
              <button type="submit" class="btn btn-cyber" style="width: 100%; font-size: 15px;">Register Identity & Submit to KGC &rarr;</button>
            </div>

            <div style="margin-top: 20px; text-align: center;">
              <p style="font-size: 13px; color: var(--text-secondary);">
                Already registered? <a href="User.jsp" style="color: var(--cyan-glow); font-weight: 600; text-decoration: none;">Log In here</a>
              </p>
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
