package dao;

import model.Workout;
import util.DbConnectionUtil;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Handles all workout table actions
 */
public class WorkoutDao {

    // add new workout
    public boolean addWorkout(Workout w) {
        String sql = "INSERT INTO workout(user_id, activity_type, duration_minutes, distance_km, calories, workout_date, notes) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DbConnectionUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, w.getUserId());
            ps.setString(2, w.getActivityType());
            ps.setInt(3, w.getDurationMinutes());
            if (w.getDistanceKm() == null) ps.setNull(4, Types.NUMERIC); else ps.setDouble(4, w.getDistanceKm());
            if (w.getCalories() == null) ps.setNull(5, Types.INTEGER); else ps.setInt(5, w.getCalories());
            ps.setDate(6, Date.valueOf(w.getWorkoutDate()));
            ps.setString(7, w.getNotes());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // update existing workout
    public boolean updateWorkout(Workout w) {
        String sql = "UPDATE workout SET activity_type=?, duration_minutes=?, distance_km=?, calories=?, workout_date=?, notes=? WHERE workout_id=? AND user_id=?";
        try (Connection con = DbConnectionUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, w.getActivityType());
            ps.setInt(2, w.getDurationMinutes());
            if (w.getDistanceKm() == null) ps.setNull(3, Types.NUMERIC); else ps.setDouble(3, w.getDistanceKm());
            if (w.getCalories() == null) ps.setNull(4, Types.INTEGER); else ps.setInt(4, w.getCalories());
            ps.setDate(5, Date.valueOf(w.getWorkoutDate()));
            ps.setString(6, w.getNotes());
            ps.setInt(7, w.getWorkoutId());
            ps.setInt(8, w.getUserId());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // delete workout
    public boolean deleteWorkout(int workoutId, int userId) {
        String sql = "DELETE FROM workout WHERE workout_id=? AND user_id=?";
        try (Connection con = DbConnectionUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, workoutId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // list all workouts for a user
    public List<Workout> listWorkouts(int userId) {
        List<Workout> list = new ArrayList<>();
        String sql = "SELECT * FROM workout WHERE user_id=? ORDER BY workout_date DESC";
        try (Connection con = DbConnectionUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Workout w = new Workout();
                w.setWorkoutId(rs.getInt("workout_id"));
                w.setUserId(rs.getInt("user_id"));
                w.setActivityType(rs.getString("activity_type"));
                w.setDurationMinutes(rs.getInt("duration_minutes"));
                double dist = rs.getDouble("distance_km");
                if (!rs.wasNull()) w.setDistanceKm(dist);
                int cal = rs.getInt("calories");
                if (!rs.wasNull()) w.setCalories(cal);
                Date d = rs.getDate("workout_date");
                if (d != null) w.setWorkoutDate(d.toLocalDate());
                w.setNotes(rs.getString("notes"));
                list.add(w);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
