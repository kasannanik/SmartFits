package controller;

import dao.UserDao;
import model.User;
import util.AlertUtil;
import util.PasswordUtil;
import util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class SignUpServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // just open the signup page
        req.getRequestDispatcher("/signup.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // get all the fields
        String name = req.getParameter("name");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String repass = req.getParameter("repassword");
        String email = req.getParameter("email");

        // check basic stuff
        if (!ValidationUtil.isNotEmpty(name) || !ValidationUtil.isNotEmpty(username) || !ValidationUtil.isNotEmpty(password)) {
            AlertUtil.setError(req, "All fields are required.");
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(repass)) {
            AlertUtil.setError(req, "Passwords don't match.");
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
            return;
        }

        if (userDao.usernameExists(username)) {
            AlertUtil.setError(req, "Username already taken.");
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
            return;
        }

        // create new user object
        User u = new User();
        u.setName(name);
        u.setUsername(username);
        u.setEmail(email);
        u.setPasswordHash(PasswordUtil.hashPassword(password));

        // save it
        int newId = userDao.createUser(u);
        if (newId > 0) {
            u.setUserId(newId);
            HttpSession session = req.getSession();
            session.setAttribute("user", u);
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            AlertUtil.setError(req, "Something went wrong, try again.");
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
        }
    }
}
