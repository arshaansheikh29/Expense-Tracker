package com.expensetracker.servlet;

import com.expensetracker.util.Expense;
import com.expensetracker.util.ExpenseDAO;
import com.expensetracker.util.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.YearMonth;
import java.time.format.DateTimeParseException;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.time.format.TextStyle;

@WebServlet("/monthly-expenses")
public class MonthlyExpensesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Check whether the user is logged in
        HttpSession session = request.getSession(false);

        User user = (session == null)
                ? null
                : (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        // Get the selected month
        YearMonth selectedMonth = YearMonth.now();
        String monthParameter = request.getParameter("month");
        String errorMessage = null;

        if (monthParameter != null
                && !monthParameter.trim().isEmpty()) {
            try {
                selectedMonth = YearMonth.parse(monthParameter);
            } catch (DateTimeParseException e) {
                errorMessage = "Please select a valid month.";
            }
        }

        // Initialize expense data
        List<Expense> expenses = Collections.emptyList();

        BigDecimal monthlyTotal = BigDecimal.ZERO;

        Map<String, BigDecimal> categorySummary =
                new LinkedHashMap<>();

        // Load expenses and category summary for the selected month
        if (errorMessage == null) {
            try {
                ExpenseDAO expenseDAO = new ExpenseDAO();

                int year = selectedMonth.getYear();
                int month = selectedMonth.getMonthValue();
                int userId = user.getId();

                // Fetch individual expenses
                expenses = expenseDAO.getExpensesByMonth(
                        userId, year, month);

                // Calculate total monthly expenses
                for (Expense expense : expenses) {
                    if (expense.getAmount() != null) {
                        monthlyTotal = monthlyTotal.add(
                                expense.getAmount());
                    }
                }

                // Fetch category-wise expenses for the same month
                categorySummary =
                        expenseDAO.getCategorySummaryByMonth(
                                userId, year, month);

            } catch (SQLException e) {
                getServletContext().log(
                        "Unable to load monthly expenses.", e);

                throw new ServletException(
                        "Unable to load monthly expenses.", e);
            }
        }

        // Send data to monthlyExpenses.jsp
        request.setAttribute("expenses", expenses);
        request.setAttribute("monthlyTotal", monthlyTotal);

        request.setAttribute(
                "categorySummary", categorySummary);

        request.setAttribute(
                "selectedMonth", selectedMonth.toString());

        request.setAttribute(
                "monthLabel",
                selectedMonth.getMonth().getDisplayName(
                        TextStyle.FULL, Locale.ENGLISH)
                        + " " + selectedMonth.getYear());

        request.setAttribute("errorMessage", errorMessage);

        // Open the monthly expenses page
        request.getRequestDispatcher("/monthlyExpenses.jsp")
                .forward(request, response);
    }
}
