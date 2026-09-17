/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package FUZZY;

/**
 *
 * @author java1
 */
import java.io.File;
import java.io.FileInputStream;
import org.apache.commons.net.ftp.FTPClient;

public class FTPcon {

    FTPClient client = new FTPClient();
    FileInputStream fis = null;
    boolean status;

    /**
     *
     * @param file
     * @return
     */
    public boolean upload(File file) {
        try {
            System.out.println("Attempting optional remote FTP backup (DriveHQ)...");
            client.setDefaultTimeout(3000);
            client.setDataTimeout(3000);
            client.connect("ftp.drivehq.com");
            client.login("CloudComputing", "publicclouds");
            client.enterLocalPassiveMode();
            fis = new FileInputStream(file);
            status = client.storeFile("/cloud/" + file.getName(), fis);
            client.logout();
            fis.close();
        } catch (Exception e) {
            System.out.println("Remote FTP backup skipped (offline/local mode active): " + e.getMessage());
            status = false;
        } finally {
            try {
                if (fis != null) {
                    fis.close();
                }
                if (client != null && client.isConnected()) {
                    client.disconnect();
                }
            } catch (Exception ex) {
            }
        }
        if (status) {
            System.out.println("Remote FTP backup: success");
            return true;
        } else {
            System.out.println("Remote FTP backup: unavailable (continuing with local storage)");
            return false;
        }
    }
}

