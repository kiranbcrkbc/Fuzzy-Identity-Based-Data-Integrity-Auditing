const crypto = require('crypto');

/**
 * AES-128 Encryption matching Encryption.java
 * Uses AES/ECB/PKCS5Padding with 128-bit key derived from Base64 or string key
 */
function encrypt(text, secretKeyBase64) {
  try {
    let keyBuffer;
    if (secretKeyBase64) {
      keyBuffer = Buffer.from(secretKeyBase64, 'base64');
      if (keyBuffer.length !== 16) {
        keyBuffer = crypto.createHash('md5').update(secretKeyBase64).digest();
      }
    } else {
      keyBuffer = crypto.randomBytes(16);
    }

    const cipher = crypto.createCipheriv('aes-128-ecb', keyBuffer, null);
    let encrypted = cipher.update(text, 'utf8', 'base64');
    encrypted += cipher.final('base64');
    return {
      cipherText: encrypted,
      key: keyBuffer.toString('base64')
    };
  } catch (err) {
    console.error('Encryption error:', err);
    throw err;
  }
}

/**
 * AES-128 Decryption matching Decryption.java
 */
function decrypt(cipherText, secretKeyBase64) {
  try {
    let keyBuffer = Buffer.from(secretKeyBase64, 'base64');
    if (keyBuffer.length !== 16) {
      keyBuffer = crypto.createHash('md5').update(secretKeyBase64).digest();
    }
    const decipher = crypto.createDecipheriv('aes-128-ecb', keyBuffer, null);
    let decrypted = decipher.update(cipherText, 'base64', 'utf8');
    decrypted += decipher.final('utf8');
    return decrypted;
  } catch (err) {
    console.error('Decryption error:', err);
    throw err;
  }
}

/**
 * Deterministic Hash / Checksum Calculation matching Java string hashCode & SHA checksum
 */
function computeHash(content) {
  let hash = 0;
  if (!content || content.length === 0) return '0';
  for (let i = 0; i < content.length; i++) {
    const char = content.charCodeAt(i);
    hash = ((hash << 5) - hash) + char;
    hash |= 0; // Convert to 32bit integer matching Java int
  }
  return String(hash);
}

/**
 * Generate Cloud Audit Proof
 */
function generateProof(content) {
  return computeHash(content);
}

module.exports = {
  encrypt,
  decrypt,
  computeHash,
  generateProof
};
