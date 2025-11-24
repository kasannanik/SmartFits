package dao;

import model.User;
import util.DbConnectionUtil;

import java.sql.*;

/**
 * All user related DB stuff here
 */
public class UserDao {

    // check if username already taken
    public boolean usernameExists(String username) {
        String sql = "SELECT user_id FROM app_user WHERE username = ?";
        try (Connection con = DbConnectionUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // create new user
    public int createUser(User u) {
        String sql = "INSERT INTO app_user(name, username, password_hash, email) VALUES (?, ?, ?, ?) RETURNING user_id";
        try (Connection con = DbConnectionUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, u.getName());
            ps.setString(2, u.getUsername());
            ps.setString(3, u.getPasswordHash());
            ps.setString(4, u.getEmail());
            ResultSet rs = ps.executeQuery();

            if (rs.next())
                return rs.getInt("user_id");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // find user by username (for login)
    public User findByUsername(String username) {
        String sql = "SELECT * FROM app_user WHERE username = ?";
        try (Connection con = DbConnectionUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setName(rs.getString("name"));
                u.setUsername(rs.getString("username"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setEmail(rs.getString("email"));
                return u;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // update user profile (name + email)
    public boolean updateProfile(User u) {
        String sql = "UPDATE app_user SET name = ?, email = ? WHERE user_id = ?";
        try (Connection con = DbConnectionUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setInt(3, u.getUserId());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // update only password
    public boolean updatePassword(int id, String hash) {
        String sql = "UPDATE app_user SET password_hash = ? WHERE user_id = ?";
        try (Connection con = DbConnectionUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, hash);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
