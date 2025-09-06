package com.shashi.DAO;

import com.shashi.DAO.UserDAO;
import com.shashi.DTO.User;

import java.sql.*;
import java.util.UUID;
import java.security.SecureRandom;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class UserDAO {
    private static final int ITERATIONS = 10000;
    private static final int KEY_LENGTH = 256;
    private static final int SALT_LENGTH = 32;
    
    public User getUserBySession(String sessionId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = OracleDBConnection.getConnection();
            String sql = "SELECT u.* FROM compile_zen_users u " +
                       "JOIN user_sessions s ON u.user_id = s.user_id " +
                       "WHERE s.session_id = ? AND s.expires_at > CURRENT_TIMESTAMP";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, sessionId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            return null;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
    
    public boolean registerUser(User user, String plainPassword) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            String salt = generateSalt();
            String hashedPassword = hashPassword(plainPassword, salt);
            
            user.setPasswordHash(hashedPassword);
            user.setSalt(salt);
            
            conn = OracleDBConnection.getConnection();
            String sql = "INSERT INTO compile_zen_users (full_name, email, password_hash, salt) VALUES (?, ?, ?, ?)";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPasswordHash());
            stmt.setString(4, user.getSalt());
            
            return stmt.executeUpdate() > 0;
        } finally {
            closeResources(conn, stmt, null);
        }
    }
    
    public User authenticateUser(String email, String password) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = OracleDBConnection.getConnection();
            String sql = "SELECT * FROM compile_zen_users WHERE email = ? AND is_active = 1";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                User user = extractUserFromResultSet(rs);
                if (hashPassword(password, user.getSalt()).equals(user.getPasswordHash())) {
                    updateLastLogin(user.getUserId());
                    return user;
                }
            }
            return null;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
    
    public void updateLastLogin(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = OracleDBConnection.getConnection();
            String sql = "UPDATE compile_zen_users SET last_login = CURRENT_TIMESTAMP WHERE user_id = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } finally {
            closeResources(conn, stmt, null);
        }
    }
    
    public String createSession(int userId, String ipAddress) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            String sessionId = UUID.randomUUID().toString();
            
            conn = OracleDBConnection.getConnection();
            String sql = "INSERT INTO user_sessions (session_id, user_id, expires_at, ip_address) " +
                       "VALUES (?, ?, CURRENT_TIMESTAMP + INTERVAL '1' HOUR, ?)";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, sessionId);
            stmt.setInt(2, userId);
            stmt.setString(3, ipAddress);
            
            stmt.executeUpdate();
            return sessionId;
        } finally {
            closeResources(conn, stmt, null);
        }
    }
    
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setSalt(rs.getString("salt"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setLastLogin(rs.getTimestamp("last_login"));
        user.setActive(rs.getInt("is_active") == 1);
        return user;
    }
    
    private void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) OracleDBConnection.closeConnection(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    private String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return bytesToHex(salt);
    }
    
    private String hashPassword(String password, String salt) {
        try {
            PBEKeySpec spec = new PBEKeySpec(
                password.toCharArray(), 
                hexToBytes(salt), 
                ITERATIONS, 
                KEY_LENGTH
            );
            SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            byte[] hash = skf.generateSecret(spec).getEncoded();
            return bytesToHex(hash);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException("Error while hashing password", e);
        }
    }
    
    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
    
    private static byte[] hexToBytes(String hex) {
        int len = hex.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(hex.charAt(i), 16) << 4)
                             + Character.digit(hex.charAt(i+1), 16));
        }
        return data;
    }
}