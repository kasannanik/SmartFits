package controller;

import dao.UserDao;
import model.User;
import util.AlertUtil;
import util.PasswordUtil;
import util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class SignInServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // open the login page
        req.getRequestDispatcher("/signin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // get login data
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (!ValidationUtil.isNotEmpty(username) || !ValidationUtil.isNotEmpty(password)) {
            AlertUtil.setError(req, "Enter username and password.");
            req.getRequestDispatcher("/signin.jsp").forward(req, resp);
            return;
        }

        // check if user exists
        User u = userDao.findByUsername(username);
        if (u == null || !PasswordUtil.checkPassword(password, u.getPasswordHash())) {
            AlertUtil.setError(req, "Invalid username or password.");
            req.getRequestDispatcher("/signin.jsp").forward(req, resp);
            return;
        }

        // login ok
        HttpSession session = req.getSession();
        session.setAttribute("user", u);
        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }
}
