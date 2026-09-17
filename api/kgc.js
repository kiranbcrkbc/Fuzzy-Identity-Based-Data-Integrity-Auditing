const db = require('./lib/db');

module.exports = async (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();

  const action = req.query.action || (req.body && req.body.action);

  try {
    // 1. List Users for KGC
    if (req.method === 'GET' || action === 'list') {
      const users = await db.query('SELECT * FROM user');
      const safeUsers = (users || []).map(u => ({
        id: u.id,
        name: u.name,
        email: u.email,
        dob: u.dob,
        gender: u.gender,
        phone: u.phone,
        city: u.city,
        country: u.country,
        kgc: u.kgc,
        status: u.status
      }));
      return res.status(200).json({ success: true, users: safeUsers });
    }

    // 2. Approve and Issue KGC Private Key
    if (action === 'approve') {
      const { userId } = req.body || {};
      if (!userId) {
        return res.status(400).json({ success: false, message: 'User ID required' });
      }

      // Generate random 6-digit key matching Java FUZZYxxxxxx
      const randKey = 'FUZZY' + Math.floor(100000 + Math.random() * 900000);
      await db.query('UPDATE user SET kgc = ? WHERE id = ?', [randKey, userId]);

      return res.status(200).json({
        success: true,
        message: 'KGC Private Key generated and bound to user identity successfully!',
        issuedKey: randKey
      });
    }

    return res.status(400).json({ success: false, message: 'Invalid action parameter' });
  } catch (err) {
    console.error('KGC error:', err);
    return res.status(500).json({ success: false, message: err.message });
  }
};
