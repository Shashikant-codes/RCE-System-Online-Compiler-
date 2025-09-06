package com.shashi.DAO;

import java.sql.Connection;
import java.sql.SQLException;
import oracle.jdbc.pool.OracleDataSource;

public class OracleDBConnection {
    // Database connection parameters
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:orcl";
    private static final String DB_USER = "MYDB2PM";
    private static final String DB_PASSWORD = "MYDB2PM";
    
    // Oracle DataSource instance
    private static OracleDataSource dataSource;
    
    // Static initializer block to set up the DataSource
    static {
        initializeDataSource();
    }
    
    /**
     * Initializes the Oracle DataSource with connection parameters
     */
    private static void initializeDataSource() {
        try {
            dataSource = new OracleDataSource();
            // Set connection properties
            dataSource.setURL(DB_URL);
            dataSource.setUser(DB_USER);
            dataSource.setPassword(DB_PASSWORD);
            
//            // Optional: Configure connection pool properties
//            dataSource.setConnectionCachingEnabled(true);
//            dataSource.setInitialLimit(5);      // Initial number of connections
//            dataSource.setMinLimit(5);          // Minimum number of connections
//            dataSource.setMaxLimit(20);         // Maximum number of connections
//            dataSource.setInactiveConnectionTimeout(300); // 5 minutes timeout
            
        } catch (SQLException e) {
            System.err.println("Failed to initialize Oracle DataSource:");
            e.printStackTrace();
            throw new RuntimeException("Database initialization failed", e);
        }
    }
    
    /**
     * Gets a database connection from the pool
     * @return Connection object
     * @throws SQLException if connection cannot be established
     */
    public static Connection getConnection() throws SQLException {
        try {
            return dataSource.getConnection();
        } catch (SQLException e) {
            System.err.println("Failed to get database connection:");
            e.printStackTrace();
            throw e;
        }
    }
    
    /**
     * Closes the database connection safely
     * @param conn Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.err.println("Error while closing connection:");
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Test the database connection (for initialization checks)
     */
    public static boolean testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            return conn.isValid(2); // 2 second timeout
        } catch (SQLException e) {
            return false;
        } finally {
            closeConnection(conn);
        }
    }
}