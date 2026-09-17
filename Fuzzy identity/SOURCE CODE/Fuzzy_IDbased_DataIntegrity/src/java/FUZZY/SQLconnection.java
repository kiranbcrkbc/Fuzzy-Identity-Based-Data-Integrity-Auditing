/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package FUZZY;

/**
 *
 * @author java1
 */
import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author java3
 */
public class SQLconnection {

    /**
     *
     * @return
     */
    public static Connection getconnection() {
        Connection con = null;
        String dbHost = System.getenv("DB_HOST");
        if (dbHost == null || dbHost.trim().isEmpty()) {
            dbHost = "localhost";
        }
        String dbPort = System.getenv("DB_PORT");
        if (dbPort == null || dbPort.trim().isEmpty()) {
            dbPort = "3306";
        }
        String dbName = System.getenv("DB_NAME");
        if (dbName == null || dbName.trim().isEmpty()) {
            dbName = "fuzzy";
        }
        String dbUser = System.getenv("DB_USER");
        if (dbUser == null || dbUser.trim().isEmpty()) {
            dbUser = "root";
        }
        String dbPass = System.getenv("DB_PASS");
        if (dbPass == null) {
            dbPass = "root";
        }
        String dbUrl = System.getenv("DB_URL");
        if (dbUrl == null || dbUrl.trim().isEmpty()) {
            dbUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        } catch (Exception e) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            } catch (Exception ex) {
                System.err.println("SQLconnection Error: " + ex.getMessage());
            }
        }
        return con;
    }

    public static void close(Connection con, java.sql.Statement st, java.sql.ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (st != null) st.close(); } catch (Exception ignored) {}
        try { if (con != null) con.close(); } catch (Exception ignored) {}
    }

    public static void close(Connection con, java.sql.Statement st) {
        close(con, st, null);
    }
}
