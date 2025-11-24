package controller;

import dao.GoalDao;
import model.Goal;
import model.User;
import util.AlertUtil;
import util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class GoalServlet extends HttpServlet {

    private GoalDao goalDao = new GoalDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // check login
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        // show all goals
        User u = (User) s.getAttribute("user");
        List<Goal> list = goalDao.listGoals(u.getUserId());
        req.setAttribute("goals", list);
        req.getRequestDispatcher("/goals.jsp").forward(req, resp);
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
            // add new goal
            String title = req.getParameter("goal_title");
            String type = req.getParameter("goal_type");
            String value = req.getParameter("goal_value");

            if (!ValidationUtil.isNotEmpty(title) || !ValidationUtil.isNotEmpty(type)) {
                AlertUtil.setError(req, "Fill all goal fields.");
                doGet(req, resp);
                return;
            }

            double val = Double.parseDouble(value);
            Goal g = new Goal();
            g.setUserId(u.getUserId());
            g.setGoalTitle(title);
            g.setGoalType(type);
            g.setGoalValue(val);

            if (goalDao.addGoal(g))
                AlertUtil.setSuccess(req, "Goal added.");
            else
                AlertUtil.setError(req, "Failed to add goal.");

            doGet(req, resp);
            return;
        }

        if ("achieve".equals(action)) {
            // mark as achieved
            String id = req.getParameter("goal_id");
            if (id != null && id.matches("\\d+")) {
                if (goalDao.markAchieved(Integer.parseInt(id), u.getUserId()))
                    AlertUtil.setSuccess(req, "Goal marked achieved.");
                else
                    AlertUtil.setError(req, "Something went wrong.");
            }
            doGet(req, resp);
        }
    }
}
