/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package FUZZY;

/**
 *
 * @author java1
 */
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class Mail {
    
public static boolean secretMail(String msg, String name, String email) {
        System.out.println("[NOTIFICATION DISPATCH] To: " + email + " | Message: " + msg);
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class",
                "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", "465");
        props.put("mail.smtp.connectiontimeout", "3000");
        props.put("mail.smtp.timeout", "3000");
        // Assuming you are sending email from localhost
        Session session = Session.getDefaultInstance(props,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication("cryptographicmail@gmail.com", "mailpassword");
                    }
                });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(name));
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(email));
            message.setSubject("CLOUD SERVER");
            message.setText("" + msg);

            Transport.send(message);

            System.out.println("Email sent successfully to: " + email);
            return true;

        } catch (Exception e) {
            System.out.println("External email delivery skipped (offline/local mode active): " + e.getMessage());
            return false;
        }
    }
}


