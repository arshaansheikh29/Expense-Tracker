package com.expensetracker.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.expensetracker.util.Expense;
import com.expensetracker.util.ExpenseDAO;
import com.expensetracker.util.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/view-expenses")
public class ViewExpensesServlet extends HttpServlet {

    private final ExpenseDAO expenseDAO = new ExpenseDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session == null) ? null
                : (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        try {
            List<Expense> expenses =
                    expenseDAO.getAllExpenses(user.getId());

            request.setAttribute("expenses", expenses);

            request.getRequestDispatcher("/viewExpenses.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to retrieve expenses.", e);
        }
    }
}
