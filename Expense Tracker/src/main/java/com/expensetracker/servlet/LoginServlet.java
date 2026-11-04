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
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.isBlank()
                || password == null || password.isBlank()) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp?error=invalid"
            );
            return;
        }

        try {
            User user = userDAO.loginUser(
                email.trim().toLowerCase(), password
            );

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                response.sendRedirect(
                    request.getContextPath() + "/dashboard.jsp"
                );
            } else {
                response.sendRedirect(
                    request.getContextPath() + "/login.jsp?error=invalid"
                );
            }
        } catch (SQLException e) {
            throw new ServletException("Unable to log in.", e);
        }
    }
}
