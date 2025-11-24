package controller;

import dao.UserDao;
import model.User;
import util.AlertUtil;
import util.PasswordUtil;
import util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ProfileServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // make sure user is logged in
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        // show profile page
        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
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

        if ("updateProfile".equals(action)) {
            // update basic info
            String name = req.getParameter("name");
            String email = req.getParameter("email");

            if (!ValidationUtil.isNotEmpty(name)) {
                AlertUtil.setError(req, "Name can't be empty.");
                req.getRequestDispatcher("/profile.jsp").forward(req, resp);
                return;
            }

            u.setName(name);
            u.setEmail(email);

            if (userDao.updateProfile(u)) {
                AlertUtil.setSuccess(req, "Profile updated.");
                s.setAttribute("user", u);
            } else {
                AlertUtil.setError(req, "Update failed.");
            }

            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
            return;
        }

        if ("changePassword".equals(action)) {
            // change password
            String current = req.getParameter("currentPassword");
            String newPass = req.getParameter("newPassword");
            String rePass = req.getParameter("confirmPassword"); // ✅ fixed (was rePassword before)

            if (!PasswordUtil.checkPassword(current, u.getPasswordHash())) {
                AlertUtil.setError(req, "Current password is wrong.");
                req.getRequestDispatcher("/profile.jsp").forward(req, resp);
                return;
            }

            if (!ValidationUtil.isNotEmpty(newPass) || !ValidationUtil.isNotEmpty(rePass)) {
                AlertUtil.setError(req, "Password fields cannot be empty.");
                req.getRequestDispatcher("/profile.jsp").forward(req, resp);
                return;
            }

            if (!newPass.equals(rePass)) {
                AlertUtil.setError(req, "New passwords don't match.");
                req.getRequestDispatcher("/profile.jsp").forward(req, resp);
                return;
            }

            String hash = PasswordUtil.hashPassword(newPass);
            if (userDao.updatePassword(u.getUserId(), hash)) {
                u.setPasswordHash(hash);
                s.setAttribute("user", u);
                AlertUtil.setSuccess(req, "Password changed successfully.");
            } else {
                AlertUtil.setError(req, "Something went wrong while updating password.");
            }

            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
        }
    }
}
