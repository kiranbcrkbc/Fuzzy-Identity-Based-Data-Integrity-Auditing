const db = require('./lib/db');

module.exports = async (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();

  const action = req.query.action || (req.body && req.body.action);

  try {
    const { filekey, corruptedHash, originalHash } = req.body || {};

    if (action === 'corrupt') {
      if (!filekey) return res.status(400).json({ success: false, message: 'filekey required' });
      const badHash = corruptedHash || 'TAMPERED_MALICIOUS_HASH_X99';

      await db.query('UPDATE fileupload SET hashcode = ? WHERE filekey = ?', [badHash, filekey]);

      return res.status(200).json({
        success: true,
        message: 'Deliberate tampering simulated! File hash corrupted in repository.',
        filekey,
        corruptedHash: badHash
      });
    }

    if (action === 'restore') {
      if (!filekey || !originalHash) {
        return res.status(400).json({ success: false, message: 'filekey and originalHash required' });
      }

      await db.query('UPDATE fileupload SET hashcode = ? WHERE filekey = ?', [originalHash, filekey]);

      return res.status(200).json({
        success: true,
        message: 'Original cryptographic hash restored. System integrity verified clean.',
        filekey,
        restoredHash: originalHash
      });
    }

    return res.status(400).json({ success: false, message: 'Invalid action (use corrupt or restore)' });
  } catch (err) {
    console.error('Tampering test error:', err);
    return res.status(500).json({ success: false, message: err.message });
  }
};
