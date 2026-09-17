import java.sql.*;

public class TestDB {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fuzzy?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");
            System.out.println("SUCCESS: Connected to MySQL database fuzzy!");
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SHOW TABLES");
            while (rs.next()) {
                System.out.println("Table: " + rs.getString(1));
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
