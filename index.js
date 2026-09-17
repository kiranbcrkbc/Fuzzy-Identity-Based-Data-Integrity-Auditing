const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');

const authHandler = require('./api/auth');
const kgcHandler = require('./api/kgc');
const filesHandler = require('./api/files');
const auditHandler = require('./api/audit');
const cloudHandler = require('./api/cloud');
const tpaHandler = require('./api/tpa');
const tamperHandler = require('./api/tamper');

const mimeTypes = {
  '.html': 'text/html',
  '.css': 'text/css',
  '.js': 'text/javascript',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml'
};

async function handler(req, res) {
  const parsedUrl = url.parse(req.url, true);
  let pathname = parsedUrl.pathname;

  // If Vercel or proxy rewrote the URL to /index or /index.js, recover original URL
  if (pathname === '/index.js' || pathname === '/index') {
    const orig = req.headers['x-matched-path'] || req.headers['x-forwarded-uri'] || req.headers['x-now-route-matches'];
    if (orig) {
      const parsedOrig = url.parse(orig, true);
      pathname = parsedOrig.pathname;
      req.query = Object.assign({}, parsedOrig.query, parsedUrl.query, req.query);
    }
  }

  // Augment res with standard Express/Vercel helpers
  if (!res.status) {
    res.status = function(statusCode) {
      this.statusCode = statusCode;
      return this;
    };
  }
  if (!res.json) {
    res.json = function(data) {
      this.setHeader('Content-Type', 'application/json');
      this.end(JSON.stringify(data));
      return this;
    };
  }

  req.query = req.query || parsedUrl.query || {};

  // Diagnostic Ping
  if (pathname === '/api/ping') {
    return res.status(200).json({
      status: 'ok',
      time: new Date().toISOString(),
      resolvedPath: pathname,
      reqUrl: req.url,
      xMatchedPath: req.headers['x-matched-path']
    });
  }

  // 1. API Route Dispatching
  if (pathname.startsWith('/api/')) {
    if (pathname === '/api/auth') return authHandler(req, res);
    if (pathname === '/api/kgc') return kgcHandler(req, res);
    if (pathname === '/api/files') return filesHandler(req, res);
    if (pathname === '/api/audit') return auditHandler(req, res);
    if (pathname === '/api/cloud') return cloudHandler(req, res);
    if (pathname === '/api/tpa') return tpaHandler(req, res);
    if (pathname === '/api/tamper') return tamperHandler(req, res);
    return res.status(404).json({ error: 'Endpoint not found' });
  }

  // 2. Static File Serving
  let filePath = path.join(__dirname, 'public', pathname === '/' ? 'index.html' : pathname);
  if (!path.extname(filePath)) {
    if (fs.existsSync(filePath + '.html')) {
      filePath += '.html';
    } else if (fs.existsSync(path.join(filePath, 'index.html'))) {
      filePath = path.join(filePath, 'index.html');
    }
  }

  if (fs.existsSync(filePath) && fs.statSync(filePath).isFile()) {
    const ext = path.extname(filePath).toLowerCase();
    const contentType = mimeTypes[ext] || 'application/octet-stream';
    res.writeHead(200, { 'Content-Type': contentType });
    fs.createReadStream(filePath).pipe(res);
  } else {
    // Fallback to index.html
    const indexPath = path.join(__dirname, 'public', 'index.html');
    if (fs.existsSync(indexPath)) {
      res.writeHead(200, { 'Content-Type': 'text/html' });
      fs.createReadStream(indexPath).pipe(res);
    } else {
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      res.end('404 Not Found');
    }
  }
}

// Local Execution
if (require.main === module) {
  const PORT = process.env.PORT || 3000;
  const server = http.createServer(handler);
  server.listen(PORT, () => {
    console.log(`Server listening on http://localhost:${PORT}`);
  });
}

module.exports = handler;
