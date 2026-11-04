<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="com.expensetracker.util.User" %>
<%@ page import="com.expensetracker.util.ExpenseDAO" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.math.RoundingMode" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.time.YearMonth" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    BigDecimal totalExpenses = BigDecimal.ZERO;
    int expenseCount = 0;

    Map<String, BigDecimal> categorySummary =
            new LinkedHashMap<>();

    Map<String, BigDecimal> monthlySummary =
            new LinkedHashMap<>();

    String summaryError = null;

    try {
        ExpenseDAO expenseDAO = new ExpenseDAO();

        totalExpenses = expenseDAO.getTotalExpenses(user.getId());
        expenseCount = expenseDAO.getExpenseCount(user.getId());

        categorySummary =
                expenseDAO.getCategorySummary(user.getId());

        monthlySummary =
                expenseDAO.getMonthlySummary(user.getId());

    } catch (SQLException e) {
        application.log("Unable to load dashboard expense summary.", e);
        summaryError = "Unable to load expense summary. Please refresh the page.";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Dashboard - Expense Tracker</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f6fa;
            color: #263238;
        }

        header {
            background: #1769aa;
            color: white;
            padding: 20px 6%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        header h2 {
            margin: 0;
        }

        main {
            max-width: 1000px;
            margin: 40px auto;
            padding: 20px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 3px 12px #0001;
            margin-bottom: 20px;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .summary-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 3px 12px #0001;
            border-left: 5px solid #1769aa;
        }

        .summary-card h3 {
            margin: 0 0 12px;
            color: #546e7a;
            font-size: 16px;
        }

        .summary-value {
            margin: 0;
            color: #1769aa;
            font-size: 30px;
            font-weight: bold;
            overflow-wrap: anywhere;
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }

        a.button {
            display: inline-block;
            background: #1769aa;
            color: white;
            padding: 12px 18px;
            text-decoration: none;
            border-radius: 6px;
        }

        a.button:hover {
            background: #0d528a;
        }

        a.logout {
            background: #c62828;
        }

        a.logout:hover {
            background: #a61f1f;
        }

        .error-message {
            color: #b71c1c;
            margin-top: 0;
        }

        .category-table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        .category-table {
            width: 100%;
            border-collapse: collapse;
        }

        .category-table th,
        .category-table td {
            padding: 14px 12px;
            border-bottom: 1px solid #eeeeee;
        }

        .category-table th {
            background: #f3f6fa;
            text-align: left;
        }

        .category-table .amount {
            text-align: right;
            white-space: nowrap;
        }

        .category-table tbody tr:hover {
            background: #f8fbff;
        }

        .empty-message {
            color: #607d8b;
            margin-bottom: 0;
        }

        .section-description {
            color: #607d8b;
        }

        @media (max-width: 600px) {
            .summary-grid {
                grid-template-columns: 1fr;
            }

            main {
                margin: 20px auto;
                padding: 15px;
            }

            .card,
            .summary-card {
                padding: 20px;
            }

            .summary-value {
                font-size: 26px;
            }
        }
    </style>
</head>

<body>

<header>
    <h2>Expense Tracker</h2>

    <a class="button logout"
       href="<%= request.getContextPath() %>/logout">
        Logout
    </a>
</header>

<main>

    <!-- Welcome Section -->
    <div class="card">
        <h1>Welcome, <%= user.getName() %>!</h1>
        <p>Manage your expenses in one place.</p>
    </div>

    <% if (summaryError != null) { %>

        <p class="error-message"><%= summaryError %></p>

    <% } else { %>

        <!-- Expense Summary Cards -->
        <div class="summary-grid">

            <div class="summary-card">
                <h3>Total Expenses</h3>

                <p class="summary-value">
                    ₹<%= totalExpenses
                        .setScale(2, RoundingMode.HALF_UP)
                        .toPlainString() %>
                </p>
            </div>

            <div class="summary-card">
                <h3>Number of Expenses</h3>

                <p class="summary-value">
                    <%= expenseCount %>
                </p>
            </div>

        </div>

        <!-- Category-wise Expense Summary -->
        <div class="card">
            <h2>Category-wise Expenses</h2>

            <% if (categorySummary.isEmpty()) { %>

                <p class="empty-message">
                    No expenses recorded yet. Add an expense to see
                    your category-wise summary.
                </p>

            <% } else { %>

                <div class="category-table-wrapper">
                    <table class="category-table">

                        <thead>
                            <tr>
                                <th>Category</th>
                                <th class="amount">Total Spent</th>
                            </tr>
                        </thead>

                        <tbody>
                            <% for (Map.Entry<String, BigDecimal> entry
                                    : categorySummary.entrySet()) { %>

                                <tr>
                                    <td>
                                        <%= entry.getKey() == null
                                                || entry.getKey().trim().isEmpty()
                                                ? "Uncategorized"
                                                : entry.getKey() %>
                                    </td>

                                    <td class="amount">
                                        ₹<%= entry.getValue()
                                            .setScale(2, RoundingMode.HALF_UP)
                                            .toPlainString() %>
                                    </td>
                                </tr>

                            <% } %>
                        </tbody>

                    </table>
                </div>

            <% } %>
        </div>

        <!-- Monthly Expense Summary -->
        <div class="card">
            <h2>Monthly Expense Summary</h2>

            <p class="section-description">
                Review your spending month by month.
            </p>

            <% if (monthlySummary.isEmpty()) { %>

                <p class="empty-message">
                    No monthly expense data available yet.
                    Add an expense to see your monthly summary.
                </p>

            <% } else { %>

                <div class="category-table-wrapper">
                    <table class="category-table">

                        <thead>
                            <tr>
                                <th>Month</th>
                                <th class="amount">Total Spent</th>
                            </tr>
                        </thead>

                        <tbody>
                            <% for (Map.Entry<String, BigDecimal> entry
                                    : monthlySummary.entrySet()) {

                                String monthLabel = entry.getKey();

                                try {
                                    monthLabel = YearMonth.parse(entry.getKey())
                                        .format(
                                            DateTimeFormatter.ofPattern("MMMM yyyy")
                                        );
                                } catch (java.time.format.DateTimeParseException e) {
                                    // Keep the original label if parsing fails.
                                }
                            %>

                                <tr>
                                    <td><%= monthLabel %></td>

                                    <td class="amount">
                                        ₹<%= entry.getValue()
                                            .setScale(2, RoundingMode.HALF_UP)
                                            .toPlainString() %>
                                    </td>
                                </tr>

                            <% } %>
                        </tbody>

                    </table>
                </div>

            <% } %>
        </div>

    <% } %>

    <!-- Expense Management -->
    <div class="card">
        <h2>Expense Management</h2>

        <div class="actions">

            <a class="button"
               href="<%= request.getContextPath() %>/addExpense.jsp">
                + Add Expense
            </a>

            <a class="button"
               href="<%= request.getContextPath() %>/view-expenses">
                View Expenses
            </a>
            
			<a class="button"
			   href="<%= request.getContextPath() %>/monthly-expenses">
			    Monthly Expenses
			</a>

        </div>
    </div>

</main>

</body>
</html>
