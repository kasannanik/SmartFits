package controller;

import dao.WorkoutDao;
import dao.GoalDao;
import model.User;
import model.Workout;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class DashboardServlet extends HttpServlet {

    private WorkoutDao workoutDao = new WorkoutDao();
    private GoalDao goalDao = new GoalDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // check if user logged in
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        User u = (User) s.getAttribute("user");

        // load user workouts
        List<Workout> list = workoutDao.listWorkouts(u.getUserId());
        int totalWorkouts = list.size();
        int totalDuration = list.stream().mapToInt(Workout::getDurationMinutes).sum();
        int totalCalories = list.stream().mapToInt(w -> w.getCalories() == null ? 0 : w.getCalories()).sum();

        // load goals info
        int totalGoals = goalDao.listGoals(u.getUserId()).size();
        long achievedGoals = goalDao.listGoals(u.getUserId())
                .stream()
                .filter(g -> g.isAchieved())
                .count();

        // set values for JSP
        req.setAttribute("totalWorkouts", totalWorkouts);
        req.setAttribute("totalDuration", totalDuration);
        req.setAttribute("totalCalories", totalCalories);
        req.setAttribute("totalGoals", totalGoals);
        req.setAttribute("goalsAchieved", achievedGoals);

        // pass recent workouts for chart
        req.setAttribute("workoutsRecent", list.size() > 5 ? list.subList(0, 5) : list);

        // forward to dashboard
        req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
    }
}
