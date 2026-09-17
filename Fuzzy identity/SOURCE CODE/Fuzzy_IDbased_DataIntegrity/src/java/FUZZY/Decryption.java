/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package FUZZY;

/**
 *
 * @author java1
 */
import java.util.Base64;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.util.Scanner;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import javax.swing.JOptionPane;



public class Decryption
{

public String decrypt(String txt,String skey)
{
     String decryptedtext = null;
	try
	{
             
            //converting string to secretkey
            byte[] bs=Base64.getDecoder().decode(skey);
            SecretKey sec=new SecretKeySpec(bs, "AES");
            System.out.println("converted string to seretkey:"+sec);
         
        System.out.println("secret key:"+sec);
     
        Cipher aesCipher = Cipher.getInstance("AES");//getting AES instance
	aesCipher.init(Cipher.ENCRYPT_MODE,sec);//initiating ciper encryption using secretkey
        
         byte[] byteCipherText =Base64.getDecoder().decode(txt); //decrypting data 
	
          //  System.out.println("ciper text:"+byteCipherText);
        aesCipher.init(Cipher.DECRYPT_MODE,sec,aesCipher.getParameters());//initiating ciper decryption
	         
       byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
	decryptedtext = new String(byteDecryptedText);
        
         System.out.println("Decrypted Text:"+decryptedtext);
        }
        
       
	catch(Exception e)
	{
	           System.out.println(e);	
	}
    return decryptedtext;
}

}
