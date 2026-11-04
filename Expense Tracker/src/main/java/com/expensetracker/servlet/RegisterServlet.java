package com.expensetracker.servlet;

import java.io.IOException;
import java.sql.SQLException;

import com.expensetracker.util.User;
import com.expensetracker.util.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (name == null || name.isBlank()
                || email == null || email.isBlank()
                || password == null || password.isBlank()) {

            response.sendRedirect(
                request.getContextPath() + "/register.jsp?error=empty"
            );
            return;
        }

        User user = new User(
            name.trim(),
            email.trim().toLowerCase(),
            password
        );

        try {
            if (userDAO.registerUser(user)) {
                response.sendRedirect(
                    request.getContextPath() + "/login.jsp?registered=1"
                );
            } else {
                response.sendRedirect(
                    request.getContextPath() + "/register.jsp?error=failed"
                );
            }
        } catch (SQLException e) {
            if ("23000".equals(e.getSQLState())) {
                response.sendRedirect(
                    request.getContextPath() + "/register.jsp?error=duplicate"
                );
            } else {
                throw new ServletException("Unable to register user.", e);
            }
        }
    }
}
