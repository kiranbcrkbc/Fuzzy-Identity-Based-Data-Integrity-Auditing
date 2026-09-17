const db = require('./lib/db');
const cryptoLib = require('./lib/crypto');

module.exports = async (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();

  try {
    // 1. GET: List files for user or all files
    if (req.method === 'GET') {
      const uid = req.query.uid;
      let files;
      if (uid) {
        files = await db.query('SELECT * FROM fileupload WHERE uid = ?', [String(uid)]);
      } else {
        files = await db.query('SELECT * FROM fileupload');
      }
      return res.status(200).json({ success: true, files });
    }

    // 2. POST: Upload new file
    if (req.method === 'POST') {
      req.body = await db.parseBody(req);
      const { fname, data, uid } = req.body || {};

      if (!fname || !data || !uid) {
        return res.status(400).json({ success: false, message: 'File name, content, and user ID are required' });
      }

      // Generate random file key matching Java filexxxxxxx
      const fileKey = 'file' + Math.floor(1000000 + Math.random() * 9000000);
      const currentTime = new Date().toISOString().replace('T', ' ').substring(0, 19);

      // Perform AES-128 encryption matching Encryption.java
      const encResult = cryptoLib.encrypt(data);
      const cipherText = encResult.cipherText;
      const secretKey = encResult.key;

      // Compute deterministic hashcode matching Java hashCode / SHA checksum
      const hashCode = cryptoLib.computeHash(data);

      await db.query(
        'INSERT INTO fileupload (fname, filekey, data, hashcode, time, uid) VALUES (?, ?, ?, ?, ?, ?)',
        [fname, fileKey, cipherText, hashCode, currentTime, String(uid)]
      );

      return res.status(201).json({
        success: true,
        message: 'File successfully encrypted with AES-128 and stored in Cloud Storage repository!',
        fileKey,
        cipherTextPreview: cipherText.substring(0, 48) + '...',
        secretKey,
        hashCode
      });
    }

    return res.status(405).json({ success: false, message: 'Method not allowed' });
  } catch (err) {
    console.error('File operation error:', err);
    return res.status(500).json({ success: false, message: err.message });
  }
};
