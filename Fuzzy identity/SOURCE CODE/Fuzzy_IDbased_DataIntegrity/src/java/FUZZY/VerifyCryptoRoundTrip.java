package FUZZY;

import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import java.util.Base64;

public class VerifyCryptoRoundTrip {
    public static void main(String[] args) {
        try {
            System.out.println("=== TESTING AES ENCRYPTION & DECRYPTION ROUND TRIP ===");
            KeyGenerator keyGen = KeyGenerator.getInstance("AES");
            keyGen.init(128);
            SecretKey secretKey = keyGen.generateKey();
            String keyStr = Base64.getEncoder().encodeToString(secretKey.getEncoded());
            
            String originalText = "Cloud Data Integrity Auditing with Fuzzy Identity & Cryptography Verification. Line 2 with special chars: @#$%^&*()_+{}[]:;\"'<>?,./!";
            
            Encryption enc = new Encryption();
            String encrypted = enc.encrypt(originalText, secretKey);
            System.out.println("Encrypted ciphertext: " + encrypted);
            
            Decryption dec = new Decryption();
            String decrypted = dec.decrypt(encrypted, keyStr);
            System.out.println("Decrypted plaintext: " + decrypted);
            
            if (originalText.equals(decrypted)) {
                System.out.println("CRYPTO ROUND-TRIP VERIFICATION: SUCCESS (100% MATCH)");
                System.exit(0);
            } else {
                System.err.println("CRYPTO ROUND-TRIP VERIFICATION: FAILED (MISMATCH)");
                System.exit(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(2);
        }
    }
}
