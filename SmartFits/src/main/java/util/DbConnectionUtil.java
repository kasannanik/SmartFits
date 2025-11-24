package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *DB connection utility for PostgreSQL.
 */
public class DbConnectionUtil {

    private static final String URL = "jdbc:postgresql://localhost:5432/smartfits";
    private static final String USER = "postgres";
    private static final String PASSWORD = "root"; // postgres pw

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            // driver missing
            e.printStackTrace();
        }
    }

    /**
     * Return a new connection. Caller should close it.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
