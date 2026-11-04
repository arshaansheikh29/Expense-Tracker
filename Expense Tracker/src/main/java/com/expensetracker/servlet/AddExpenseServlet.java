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

@WebServlet("/add-expense")
public class AddExpenseServlet extends HttpServlet {

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

        String title = request.getParameter("title");
        String amountText = request.getParameter("amount");
        String category = request.getParameter("category");
        String dateText = request.getParameter("expenseDate");
        String description = request.getParameter("description");

        try {
            if (title == null || title.isBlank()
                    || amountText == null || amountText.isBlank()
                    || category == null || category.isBlank()
                    || dateText == null || dateText.isBlank()) {
                response.sendRedirect(
                    request.getContextPath() + "/addExpense.jsp?error=invalid"
                );
                return;
            }

            BigDecimal amount = new BigDecimal(amountText);

            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                response.sendRedirect(
                    request.getContextPath() + "/addExpense.jsp?error=invalid"
                );
                return;
            }

            Expense expense = new Expense(
                title.trim(),
                amount,
                category.trim(),
                Date.valueOf(dateText),
                description == null ? "" : description.trim()
            );

            expense.setUserId(user.getId());

            if (expenseDAO.addExpense(expense)) {
                response.sendRedirect(
                    request.getContextPath() + "/view-expenses"
                );
            } else {
                response.sendRedirect(
                    request.getContextPath() + "/addExpense.jsp?error=failed"
                );
            }

        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                request.getContextPath() + "/addExpense.jsp?error=invalid"
            );
        } catch (SQLException e) {
            throw new ServletException("Unable to save expense.", e);
        }
    }
}
