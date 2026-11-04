package com.expensetracker.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
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

@WebServlet("/update-expense")
public class UpdateExpenseServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ExpenseDAO expenseDAO = new ExpenseDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

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
            int id = Integer.parseInt(request.getParameter("id"));

            String title = request.getParameter("title");
            String amountText = request.getParameter("amount");
            String category = request.getParameter("category");
            String dateText = request.getParameter("expenseDate");
            String description = request.getParameter("description");

            if (title == null || title.isBlank()
                    || amountText == null || amountText.isBlank()
                    || category == null || category.isBlank()
                    || dateText == null || dateText.isBlank()) {

                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Please fill in all required fields."
                );
                return;
            }

            BigDecimal amount = new BigDecimal(amountText);

            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Amount must be greater than zero."
                );
                return;
            }

            Date expenseDate = Date.valueOf(dateText);

            Expense expense = expenseDAO.getExpenseById(
                id, user.getId()
            );

            if (expense == null) {
                response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Expense not found."
                );
                return;
            }

            expense.setTitle(title.trim());
            expense.setAmount(amount);
            expense.setCategory(category.trim());
            expense.setExpenseDate(expenseDate);
            expense.setDescription(
                description == null ? "" : description.trim()
            );

            boolean updated = expenseDAO.updateExpense(
                expense, user.getId()
            );

            if (updated) {
                response.sendRedirect(
                    request.getContextPath() + "/view-expenses"
                );
            } else {
                response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Expense could not be updated."
                );
            }

        } catch (IllegalArgumentException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid expense details. Check the ID, amount, and date."
            );
        } catch (SQLException e) {
            throw new ServletException(
                "Unable to update expense.", e
            );
        }
    }
}
