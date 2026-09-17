const db = require('./lib/db');

module.exports = async (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();

  const action = req.query.action || (req.body && req.body.action);

  try {
    // 1. GET: List all audit requests
    if (req.method === 'GET' || action === 'list') {
      const requests = await db.query('SELECT * FROM audit_request');
      return res.status(200).json({ success: true, requests });
    }

    // 2. POST: Create audit challenge request
    if (action === 'request') {
      const { filekey, uid } = req.body || {};
      if (!filekey || !uid) {
        return res.status(400).json({ success: false, message: 'filekey and uid required' });
      }

      // Fetch file hash from fileupload
      const fileRows = await db.query('SELECT * FROM fileupload WHERE filekey = ?', [filekey]);
      if (!fileRows || fileRows.length === 0) {
        return res.status(404).json({ success: false, message: 'File record not found' });
      }

      const file = fileRows[0];
      const currentTime = new Date().toISOString().replace('T', ' ').substring(0, 19);

      await db.query(
        'INSERT INTO audit_request (filekey, time, uid, status, hash, hash_proof) VALUES (?, ?, ?, ?, ?, ?)',
        [filekey, currentTime, String(uid), 'waiting', file.hashcode, '']
      );

      await db.query('UPDATE fileupload SET audit_status = ? WHERE filekey = ?', ['Audition in Process', filekey]);

      return res.status(201).json({
        success: true,
        message: 'Audit verification request dispatched to Third Party Auditor (TPA) queue.',
        filekey
      });
    }

    return res.status(400).json({ success: false, message: 'Invalid action parameter' });
  } catch (err) {
    console.error('Audit request error:', err);
    return res.status(500).json({ success: false, message: err.message });
  }
};
