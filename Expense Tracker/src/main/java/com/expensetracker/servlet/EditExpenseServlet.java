package com.expensetracker.servlet;

import java.io.IOException;
import java.sql.SQLException;

import com.expensetracker.util.Expense;
import com.expensetracker.util.ExpenseDAO;
import com.expensetracker.util.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/edit-expense")
public class EditExpenseServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

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
            String idParameter = request.getParameter("id");

            if (idParameter == null || idParameter.isBlank()) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Expense ID is required."
                );
                return;
            }

            int expenseId = Integer.parseInt(idParameter);

            Expense expense = expenseDAO.getExpenseById(
                expenseId, user.getId()
            );

            if (expense == null) {
                response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Expense not found."
                );
                return;
            }

            request.setAttribute("expense", expense);

            request.getRequestDispatcher("/editExpense.jsp")
                    .forward(request, response);

        } catch (IllegalArgumentException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid expense ID."
            );
        } catch (SQLException e) {
            throw new ServletException(
                "Unable to load expense.", e
            );
        }
    }
}
