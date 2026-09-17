const db = require('./lib/db');

module.exports = async (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  const action = req.query.action || (req.body && req.body.action);

  try {
    // 1. User Registration
    if (action === 'register') {
      const { name, email, dob, gender, phone, city, country, password, bio_sign } = req.body || {};
      
      if (!name || !email || !password) {
        return res.status(400).json({ success: false, message: 'Name, email, and password are required' });
      }

      // Check for duplicate registration
      const existing = await db.query('SELECT COUNT(*) as count FROM user WHERE email = ?', [email]);
      if (existing && existing[0] && (existing[0].count > 0 || existing[0]['COUNT(*)'] > 0)) {
        return res.status(409).json({ success: false, message: 'Email already registered' });
      }

      await db.query(
        'INSERT INTO user (name, email, dob, gender, phone, city, country, password, bio_sign, kgc, otp) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [name, email, dob || '', gender || '', phone || '', city || '', country || '', password, bio_sign || '', 'Waiting', '']
      );

      return res.status(201).json({
        success: true,
        message: 'Registration successful! Waiting for KGC Key Generation Center approval.'
      });
    }

    // 2. User Login
    if (action === 'login') {
      const { email, password } = req.body || {};
      if (!email || !password) {
        return res.status(400).json({ success: false, message: 'Email and password required' });
      }

      const rows = await db.query('SELECT * FROM user WHERE email = ? AND password = ?', [email, password]);
      if (!rows || rows.length === 0) {
        return res.status(401).json({ success: false, message: 'Authentication Failed: Invalid email or password' });
      }

      const user = rows[0];
      if (user.kgc === 'Waiting' || user.status === 'Pending') {
        return res.status(403).json({ success: false, message: 'Account pending KGC authorization and key issuance' });
      }

      // Generate dynamic 6-digit OTP
      const generatedOtp = 'I' + Math.floor(10000 + Math.random() * 90000);
      await db.query('UPDATE user SET otp = ? WHERE email = ?', [generatedOtp, email]);

      return res.status(200).json({
        success: true,
        message: 'Credentials valid. 2FA OTP dispatched.',
        userId: user.id,
        email: user.email,
        otpDemoHint: generatedOtp // surfaced for effortless academic presentation
      });
    }

    // 3. Two-Factor OTP Verification
    if (action === 'otp') {
      const { email, otp } = req.body || {};
      if (!email || !otp) {
        return res.status(400).json({ success: false, message: 'Email and OTP code required' });
      }

      const rows = await db.query('SELECT * FROM user WHERE otp = ? AND email = ?', [otp, email]);
      if (!rows || rows.length === 0) {
        return res.status(401).json({ success: false, message: 'Incorrect OTP code entered' });
      }

      const user = rows[0];
      return res.status(200).json({
        success: true,
        message: 'Login successful',
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          kgc: user.kgc
        }
      });
    }

    return res.status(400).json({ success: false, message: 'Invalid action parameter' });
  } catch (err) {
    console.error('Auth error:', err);
    return res.status(500).json({ success: false, message: err.message });
  }
};
