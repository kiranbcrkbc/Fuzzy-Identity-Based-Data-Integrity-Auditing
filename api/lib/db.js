const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

// In-Memory / File Fallback Store (for seamless Vercel serverless persistence)
let memoryStore = {
  users: [
    {
      id: 1,
      name: "Kiran",
      email: "kiran@example.com",
      dob: "2000-01-01",
      gender: "Male",
      phone: "9876543210",
      city: "Bangalore",
      country: "India",
      password: "123",
      bio_sign: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==",
      kgc: "FUZZY677874",
      otp: "I00484",
      status: "Activated"
    }
  ],
  fileupload: [],
  audit_request: [],
  cloud_request: [],
  audit_proof: []
};

const DB_FILE = path.join(process.env.TEMP || '/tmp', 'fuzzy_db.json');

function loadStore() {
  try {
    if (fs.existsSync(DB_FILE)) {
      const data = fs.readFileSync(DB_FILE, 'utf8');
      if (data) {
        const parsed = JSON.parse(data);
        if (parsed.users) memoryStore.users = parsed.users;
        if (parsed.fileupload) memoryStore.fileupload = parsed.fileupload;
        if (parsed.audit_request) memoryStore.audit_request = parsed.audit_request;
        if (parsed.cloud_request) memoryStore.cloud_request = parsed.cloud_request;
        if (parsed.audit_proof) memoryStore.audit_proof = parsed.audit_proof;
      }
    }
  } catch (e) {}
}

function saveStore() {
  try {
    fs.writeFileSync(DB_FILE, JSON.stringify(memoryStore, null, 2));
  } catch (e) {}
}

// Initial load
loadStore();

// Check if MySQL connection is configured
const hasMySQL = Boolean(process.env.DB_HOST || process.env.MYSQL_URL || process.env.DATABASE_URL);
let pool = null;

if (hasMySQL) {
  try {
    pool = mysql.createPool({
      host: process.env.DB_HOST || 'localhost',
      port: Number(process.env.DB_PORT) || 3306,
      database: process.env.DB_NAME || 'fuzzy',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASS || '',
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0
    });
  } catch (err) {
    console.warn('MySQL pool initialization fallback:', err.message);
  }
}

async function query(sql, params = []) {
  if (pool) {
    try {
      const [rows] = await pool.execute(sql, params);
      return rows;
    } catch (err) {
      console.warn('MySQL execution error, falling back to serverless store:', err.message);
    }
  }
  return memoryQuery(sql, params);
}

function memoryQuery(sql, params = []) {
  loadStore();
  const normalized = sql.trim();
  const lower = normalized.toLowerCase();
  const isMutation = lower.startsWith('insert into') || lower.includes('update ') || lower.startsWith('delete from');
  const res = executeMemoryQuery(lower, params);
  if (isMutation) {
    saveStore();
  }
  return res;
}

function executeMemoryQuery(lower, params = []) {

  // 1. SELECT COUNT(*) FROM user WHERE email = ?
  if (lower.startsWith('select count(*) from user') || lower.startsWith('select count(*) as count from user')) {
    const email = params[0];
    const matches = memoryStore.users.filter(u => u.email.toLowerCase() === String(email).toLowerCase());
    return [{ 'COUNT(*)': matches.length, count: matches.length }];
  }

  // 2. SELECT * FROM user WHERE email = ? AND password = ?
  if (lower.startsWith('select * from user where email = ? and password = ?')) {
    const [email, pass] = params;
    const match = memoryStore.users.find(u => u.email.toLowerCase() === String(email).toLowerCase() && u.password === String(pass));
    return match ? [match] : [];
  }

  // 3. SELECT * FROM user WHERE otp = ? AND email = ?
  if (lower.startsWith('select * from user where otp = ? and email = ?')) {
    const [otp, email] = params;
    const match = memoryStore.users.find(u => u.otp === String(otp) && u.email.toLowerCase() === String(email).toLowerCase());
    return match ? [match] : [];
  }

  // 4. SELECT * FROM user WHERE id = ?
  if (lower.startsWith('select * from user where id = ?')) {
    const id = Number(params[0]);
    const match = memoryStore.users.find(u => u.id === id);
    return match ? [match] : [];
  }

  // 5. SELECT * FROM user (all users / requests)
  if (lower.startsWith('select * from user')) {
    return [...memoryStore.users];
  }

  // 6. INSERT INTO user
  if (lower.startsWith('insert into user')) {
    const newId = memoryStore.users.length ? Math.max(...memoryStore.users.map(u => u.id)) + 1 : 1;
    const newUser = {
      id: newId,
      name: params[0],
      email: params[1],
      dob: params[2],
      gender: params[3],
      phone: params[4],
      city: params[5],
      country: params[6],
      password: params[7],
      bio_sign: params[8] || '',
      kgc: params[9] || 'Waiting',
      otp: params[10] || '',
      status: 'Pending'
    };
    memoryStore.users.push(newUser);
    return { insertId: newId, affectedRows: 1 };
  }

  // 7. UPDATE user SET otp = ? WHERE email = ?
  if (lower.includes('update user set otp = ? where email = ?')) {
    const [otp, email] = params;
    const user = memoryStore.users.find(u => u.email.toLowerCase() === String(email).toLowerCase());
    if (user) user.otp = otp;
    return { affectedRows: user ? 1 : 0 };
  }

  // 8. UPDATE user SET kgc = ? WHERE id = ?
  if (lower.includes('update user set kgc = ? where id = ?')) {
    const [kgc, id] = params;
    const user = memoryStore.users.find(u => u.id === Number(id));
    if (user) {
      user.kgc = kgc;
      user.status = 'Activated';
    }
    return { affectedRows: user ? 1 : 0 };
  }

  // 9. INSERT INTO fileupload
  if (lower.startsWith('insert into fileupload')) {
    const newId = memoryStore.fileupload.length ? Math.max(...memoryStore.fileupload.map(f => f.id)) + 1 : 1;
    const newFile = {
      id: newId,
      fname: params[0],
      filekey: params[1],
      data: params[2],
      hashcode: params[3],
      time: params[4],
      uid: String(params[5]),
      audit_status: 'Not Audited'
    };
    memoryStore.fileupload.push(newFile);
    return { insertId: newId, affectedRows: 1 };
  }

  // 10. SELECT * FROM fileupload WHERE uid = ?
  if (lower.startsWith('select * from fileupload where uid = ?')) {
    const uid = String(params[0]);
    return memoryStore.fileupload.filter(f => f.uid === uid);
  }

  // 11. SELECT * FROM fileupload WHERE filekey = ?
  if (lower.startsWith('select * from fileupload where filekey = ?')) {
    const key = String(params[0]);
    return memoryStore.fileupload.filter(f => f.filekey === key);
  }

  // 12. SELECT * FROM fileupload
  if (lower.startsWith('select * from fileupload')) {
    return [...memoryStore.fileupload];
  }

  // 13. UPDATE fileupload SET audit_status = ? WHERE filekey = ?
  if (lower.includes('update fileupload set audit_status = ? where filekey = ?')) {
    const [status, key] = params;
    const file = memoryStore.fileupload.find(f => f.filekey === String(key));
    if (file) file.audit_status = status;
    return { affectedRows: file ? 1 : 0 };
  }

  // 14. UPDATE fileupload SET hashcode = ? WHERE filekey = ? (Tampering simulation)
  if (lower.includes('update fileupload set hashcode = ? where filekey = ?')) {
    const [hash, key] = params;
    const file = memoryStore.fileupload.find(f => f.filekey === String(key));
    if (file) file.hashcode = hash;
    return { affectedRows: file ? 1 : 0 };
  }

  // 15. INSERT INTO audit_request
  if (lower.startsWith('insert into audit_request')) {
    const newId = memoryStore.audit_request.length ? Math.max(...memoryStore.audit_request.map(a => a.id)) + 1 : 1;
    const newAudit = {
      id: newId,
      filekey: params[0],
      time: params[1],
      uid: String(params[2]),
      status: 'waiting',
      hash: params[3] || '',
      hash_proof: ''
    };
    memoryStore.audit_request.push(newAudit);
    return { insertId: newId, affectedRows: 1 };
  }

  // 16. SELECT * FROM audit_request
  if (lower.startsWith('select * from audit_request')) {
    return [...memoryStore.audit_request];
  }

  // 17. UPDATE audit_request SET status = ? WHERE filekey = ?
  if (lower.includes('update audit_request set status = ? where filekey = ?')) {
    const [status, key] = params;
    const req = memoryStore.audit_request.find(a => a.filekey === String(key));
    if (req) req.status = status;
    return { affectedRows: req ? 1 : 0 };
  }

  // 18. INSERT INTO cloud_request
  if (lower.startsWith('insert into cloud_request')) {
    const newId = memoryStore.cloud_request.length ? Math.max(...memoryStore.cloud_request.map(c => c.id)) + 1 : 1;
    const newCloud = {
      id: newId,
      filekey: params[0],
      time: params[1],
      uid: String(params[2]),
      status: 'waiting',
      hash: params[3] || ''
    };
    memoryStore.cloud_request.push(newCloud);
    return { insertId: newId, affectedRows: 1 };
  }

  // 19. SELECT * FROM cloud_request
  if (lower.startsWith('select * from cloud_request')) {
    return [...memoryStore.cloud_request];
  }

  // 20. UPDATE cloud_request SET status = ? WHERE filekey = ?
  if (lower.includes('update cloud_request set status = ? where filekey = ?')) {
    const [status, key] = params;
    const req = memoryStore.cloud_request.find(c => c.filekey === String(key));
    if (req) req.status = status;
    return { affectedRows: req ? 1 : 0 };
  }

  // 21. INSERT INTO audit_proof
  if (lower.startsWith('insert into audit_proof')) {
    const newId = memoryStore.audit_proof.length ? Math.max(...memoryStore.audit_proof.map(p => p.id)) + 1 : 1;
    const newProof = {
      id: newId,
      filekey: params[0],
      time: params[1],
      uid: String(params[2]),
      hashproof: params[3]
    };
    memoryStore.audit_proof.push(newProof);
    return { insertId: newId, affectedRows: 1 };
  }

  // 22. SELECT * FROM audit_proof WHERE filekey = ?
  if (lower.startsWith('select * from audit_proof where filekey = ?')) {
    const key = String(params[0]);
    return memoryStore.audit_proof.filter(p => p.filekey === key);
  }

  // 23. SELECT * FROM audit_proof
  if (lower.startsWith('select * from audit_proof')) {
    return [...memoryStore.audit_proof];
  }

  return [];
}

async function parseBody(req) {
  if (req.body) {
    if (typeof req.body === 'string') {
      try { return JSON.parse(req.body); } catch(e) { return {}; }
    }
    return req.body;
  }
  if (req.method === 'POST' || req.method === 'PUT') {
    let raw = '';
    req.on('data', chunk => { raw += chunk.toString(); });
    await new Promise(resolve => req.on('end', resolve));
    try { return JSON.parse(raw); } catch(e) { return {}; }
  }
  return {};
}

module.exports = {
  query,
  memoryStore,
  parseBody
};
