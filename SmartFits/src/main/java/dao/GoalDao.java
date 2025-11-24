package dao;

import model.Goal;
import util.DbConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Goal related DB operations
 */
public class GoalDao {

    // add new goal
    public boolean addGoal(Goal g) {
        String sql = "INSERT INTO goal(user_id, goal_title, goal_type, goal_value) VALUES (?, ?, ?, ?)";
        try (Connection con = DbConnectionUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, g.getUserId());
            ps.setString(2, g.getGoalTitle());
            ps.setString(3, g.getGoalType());
            ps.setDouble(4, g.getGoalValue());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // mark goal as done
    public boolean markAchieved(int goalId, int userId) {
        String sql = "UPDATE goal SET achieved=true, achieved_date=CURRENT_DATE WHERE goal_id=? AND user_id=?";
        try (Connection con = DbConnectionUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, goalId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // get all goals for one user
    public List<Goal> listGoals(int userId) {
        List<Goal> list = new ArrayList<>();
        String sql = "SELECT * FROM goal WHERE user_id=? ORDER BY created_at DESC";
        try (Connection con = DbConnectionUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Goal g = new Goal();
                g.setGoalId(rs.getInt("goal_id"));
                g.setUserId(rs.getInt("user_id"));
                g.setGoalTitle(rs.getString("goal_title"));
                g.setGoalType(rs.getString("goal_type"));
                g.setGoalValue(rs.getDouble("goal_value"));
                g.setAchieved(rs.getBoolean("achieved"));
                Date ad = rs.getDate("achieved_date");
                if (ad != null) g.setAchievedDate(ad.toLocalDate());
                list.add(g);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
