
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class App {

   public static void main(String[] args) {
     try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydatabase", "root", "Gharwal@8094");
          PreparedStatement ps = con.prepareStatement("SELECT * FROM mytable")) {
            ps.setInt(1, 1);
            ps.setString(2, "John Doe");

            ps.executeUpdate();
     } catch (SQLException e) {
         e.printStackTrace();
     }
     System.out.println(con);
     System.out.println("connection created successfully");
     con.close();
   }
}

