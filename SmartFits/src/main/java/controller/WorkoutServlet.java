package controller;

import dao.WorkoutDao;
import model.User;
import model.Workout;
import util.AlertUtil;
import util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

public class WorkoutServlet extends HttpServlet {

    private WorkoutDao workoutDao = new WorkoutDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // check login
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        // load workouts
        User u = (User) s.getAttribute("user");
        List<Workout> list = workoutDao.listWorkouts(u.getUserId());
        req.setAttribute("workouts", list);
        req.getRequestDispatcher("/workouts.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        User u = (User) s.getAttribute("user");
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            // get fields
            String activity = req.getParameter("activity_type");
            String duration = req.getParameter("duration_minutes");
            String distance = req.getParameter("distance_km");
            String calories = req.getParameter("calories");
            String date = req.getParameter("workout_date");
            String notes = req.getParameter("notes");

            // simple checks
            if (!ValidationUtil.isNotEmpty(activity) || !ValidationUtil.isNonNegativeInteger(duration) || !ValidationUtil.isValidDate(date)) {
                AlertUtil.setError(req, "Check your inputs.");
                doGet(req, resp);
                return;
            }

            Workout w = new Workout();
            w.setUserId(u.getUserId());
            w.setActivityType(activity);
            w.setDurationMinutes(Integer.parseInt(duration));
            if (distance != null && !distance.isEmpty()) w.setDistanceKm(Double.parseDouble(distance));
            if (calories != null && !calories.isEmpty()) w.setCalories(Integer.parseInt(calories));
            w.setWorkoutDate(LocalDate.parse(date));
            w.setNotes(notes);

            if (workoutDao.addWorkout(w))
                AlertUtil.setSuccess(req, "Workout added.");
            else
                AlertUtil.setError(req, "Failed to add workout.");

            doGet(req, resp);
            return;
        }

        if ("delete".equals(action)) {
            String id = req.getParameter("workout_id");
            if (id != null && id.matches("\\d+")) {
                if (workoutDao.deleteWorkout(Integer.parseInt(id), u.getUserId()))
                    AlertUtil.setSuccess(req, "Workout deleted.");
                else
                    AlertUtil.setError(req, "Delete failed.");
            }
            doGet(req, resp);
            return;
        }
        
        if ("update".equals(action)) {
            // update workout
            String id = req.getParameter("workout_id");
            String activity = req.getParameter("activity_type");
            String duration = req.getParameter("duration_minutes");
            String distance = req.getParameter("distance_km");
            String calories = req.getParameter("calories");
            String date = req.getParameter("workout_date");
            String notes = req.getParameter("notes");

            if (!ValidationUtil.isNotEmpty(activity) || !ValidationUtil.isValidDate(date)) {
                AlertUtil.setError(req, "Invalid data.");
                doGet(req, resp);
                return;
            }

            Workout w = new Workout();
            w.setWorkoutId(Integer.parseInt(id));
            w.setUserId(u.getUserId());
            w.setActivityType(activity);
            w.setDurationMinutes(Integer.parseInt(duration));
            if (distance != null && !distance.isEmpty()) w.setDistanceKm(Double.parseDouble(distance));
            if (calories != null && !calories.isEmpty()) w.setCalories(Integer.parseInt(calories));
            w.setWorkoutDate(LocalDate.parse(date));
            w.setNotes(notes);

            if (workoutDao.updateWorkout(w))
                AlertUtil.setSuccess(req, "Workout updated.");
            else
                AlertUtil.setError(req, "Update failed.");

            doGet(req, resp);
        }
    }
}
