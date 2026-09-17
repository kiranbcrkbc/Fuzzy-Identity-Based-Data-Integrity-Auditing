<%@page import="FUZZY.SQLconnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String fid = request.getParameter("fid");
    String hash1 = request.getParameter("hash");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Proof Validation & Integrity Check | Fuzzy Auditing</title>
  <link rel="stylesheet" href="css/cyber_theme.css">
  <script>
    function verifyProofMatch(event) {
      event.preventDefault();
      var h1 = document.getElementById('pwd1').value.trim();
      var h2 = document.getElementById('pwd2').value.trim();
      var resultDiv = document.getElementById('verification-result');
      
      if (h1 && h2 && h1 === h2) {
        resultDiv.innerHTML = '<div class="alert-banner success" style="margin-top: 20px;">' +
          '<span>&#10004;</span>' +
          '<div><strong>INTEGRITY VERIFIED (PASS):</strong> The cloud storage proof hash matches the original uploaded document hash exactly. Zero data corruption or tampering detected!</div>' +
          '</div>';
      } else {
        resultDiv.innerHTML = '<div class="alert-banner error" style="margin-top: 20px;">' +
          '<span>&#9888;</span>' +
          '<div><strong>INTEGRITY FAILED:</strong> Proof hash mismatch. Data corruption or cloud storage modification detected!</div>' +
          '</div>';
      }
    }
  </script>
</head>
<body>

  <!-- Top Navigation Bar -->
  <nav class="cyber-navbar">
    <div class="app-container nav-wrapper">
      <a href="User_home.jsp" class="brand-logo">
        <div class="brand-icon">V</div>
        <div class="brand-text">
          <h1>INTEGRITY VERIFICATION</h1>
          <p>Deterministic Hash Comparison</p>
        </div>
      </a>
      <ul class="nav-links">
        <li><a href="User_home.jsp">Dashboard</a></li>
        <li><a href="user_check.jsp">&larr; Back to Proofs</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Container -->
  <main class="app-container hero-section">
    <div style="max-width: 620px; margin: 30px auto;">

      <div class="cyber-card">
        <div class="card-header">
          <h3>&#128269; Cryptographic Proof Matcher</h3>
          <span class="role-badge emerald">Deterministic Check</span>
        </div>
        <div class="card-body">
          <%
              Connection con = null;
              PreparedStatement ps = null;
              ResultSet rs = null;
              try {
                  con = SQLconnection.getconnection();
                  if (con != null) {
                      ps = con.prepareStatement("SELECT * FROM fileupload WHERE filekey = ?");
                      ps.setString(1, fid != null ? fid.trim() : "");
                      rs = ps.executeQuery();
                      if (rs.next()) {
                          String storedHash = rs.getString("hashcode");
          %>
          <form onsubmit="verifyProofMatch(event);">
            
            <div class="form-group">
              <label for="fileId">File Key / Identifier</label>
              <input id="fileId" type="text" name="username" class="form-control" value="<%= fid != null ? fid : "" %>" readonly style="font-family: var(--font-mono); color: var(--cyan-glow);">
            </div>

            <div class="form-group">
              <label for="pwd1">Cloud Auditing Proof Hash (Received from Cloud Server)</label>
              <input id="pwd1" type="text" name="pwd1" class="form-control" value="<%= hash1 != null ? hash1 : "" %>" readonly style="font-family: var(--font-mono); color: var(--emerald-glow);">
            </div>

            <div class="form-group">
              <label for="pwd2">Original Upload Hash (Recorded in Database)</label>
              <input id="pwd2" type="text" name="pwd2" class="form-control" value="<%= storedHash %>" readonly style="font-family: var(--font-mono); color: var(--purple-glow);">
            </div>

            <div style="margin-top: 24px; display: flex; gap: 12px;">
              <button type="submit" class="btn btn-emerald" style="flex: 1; font-size: 15px;">&#9989; Execute Mathematical Match</button>
              <a href="user_check.jsp" class="btn btn-outline">Cancel</a>
            </div>

          </form>

          <div id="verification-result"></div>

          <%
                      } else {
          %>
          <div class="alert-banner error">
            <span>&#9888;</span>
            <div>File record not found in repository.</div>
          </div>
          <%
                      }
                  }
              } catch (Exception ex) {
          %>
          <div class="alert-banner error">
            <span>&#9888;</span>
            <div>Error: <%= ex.getMessage() %></div>
          </div>
          <%
              } finally {
                  if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                  if (ps != null) try { ps.close(); } catch (Exception ignored) {}
                  if (con != null) try { con.close(); } catch (Exception ignored) {}
              }
          %>
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
