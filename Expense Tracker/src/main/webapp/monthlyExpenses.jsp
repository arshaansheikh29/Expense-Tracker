<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.math.RoundingMode" %>
<%@ page import="com.expensetracker.util.Expense" %>
<%@ page import="com.expensetracker.util.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Expense> expenses =
        (List<Expense>) request.getAttribute("expenses");

    BigDecimal monthlyTotal =
        (BigDecimal) request.getAttribute("monthlyTotal");

    Map<String, BigDecimal> categorySummary =
        (Map<String, BigDecimal>) request.getAttribute("categorySummary");

    String selectedMonth =
        (String) request.getAttribute("selectedMonth");

    String monthLabel =
        (String) request.getAttribute("monthLabel");

    String errorMessage =
        (String) request.getAttribute("errorMessage");

    if (expenses == null) {
        expenses = java.util.Collections.emptyList();
    }

    if (monthlyTotal == null) {
        monthlyTotal = BigDecimal.ZERO;
    }

    if (categorySummary == null) {
        categorySummary = java.util.Collections.emptyMap();
    }

    if (selectedMonth == null) {
        selectedMonth = java.time.YearMonth.now().toString();
    }

    if (monthLabel == null) {
        monthLabel = selectedMonth;
    }

    // Escape text before displaying it in HTML
    java.util.function.Function<String, String> escapeHtml = value -> {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    };
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Monthly Expenses - Expense Tracker</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 25px;
            font-family: Arial, sans-serif;
            background: #f3f6fa;
            color: #263238;
        }

        .container {
            max-width: 1100px;
            margin: 55px auto 20px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 3px 12px #0001;
            margin-bottom: 20px;
        }

        h1 {
            color: #1769aa;
            text-align: center;
        }

        .month-form {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 20px;
        }

        input[type="month"] {
            padding: 11px;
            border: 1px solid #ccd5df;
            border-radius: 6px;
            font-size: 15px;
        }

        .button {
            display: inline-block;
            padding: 11px 16px;
            color: white;
            background: #1769aa;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            cursor: pointer;
            font-size: 14px;
        }

        .button:hover {
            opacity: 0.88;
        }

        .back-button {
            background: #555;
        }

        .total-card {
            border-left: 5px solid #1769aa;
        }

        .total-label {
            color: #546e7a;
            margin-bottom: 8px;
        }

        .total-value {
            font-size: 32px;
            font-weight: bold;
            color: #1769aa;
            overflow-wrap: anywhere;
        }

        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
            margin-top: 20px;
        }

        .category-card {
            padding: 18px;
            border: 1px solid #e1e8ef;
            border-radius: 10px;
            background: #fbfdff;
        }

        .category-name {
            color: #546e7a;
            font-size: 15px;
            margin-bottom: 10px;
            overflow-wrap: anywhere;
        }

        .category-amount {
            color: #1769aa;
            font-size: 23px;
            font-weight: bold;
            overflow-wrap: anywhere;
        }

        .category-percent {
            color: #607d8b;
            font-size: 13px;
            margin-top: 8px;
        }

        .progress-track {
            width: 100%;
            height: 8px;
            background: #e4ebf2;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 12px;
        }

        .progress-bar {
            height: 100%;
            background: #3984e8;
            border-radius: 10px;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background: #1769aa;
            color: white;
        }

        tbody tr:nth-child(even) {
            background: #f3f6fa;
        }

        .amount {
            white-space: nowrap;
        }

        .empty-message {
            text-align: center;
            color: #607d8b;
            padding: 20px;
        }

        .error-message {
            color: #b71c1c;
        }

        @media (max-width: 600px) {
            body {
                padding: 15px;
            }

            .card {
                padding: 18px;
            }

            .month-form {
                align-items: stretch;
                flex-direction: column;
            }

            input[type="month"] {
                width: 100%;
            }

            .total-value {
                font-size: 26px;
            }
        }
    </style>
</head>

<body>

<div style="position: absolute; top: 20px; left: 20px;">
    <a class="button back-button"
       href="<%= request.getContextPath() %>/dashboard.jsp">
        &larr; Back to Dashboard
    </a>
</div>

<div class="container">

    <div class="card">
        <h1>Monthly Expense Summary</h1>
        <p>Select a month to view your expenses and category-wise spending.</p>

        <form class="month-form"
              action="<%= request.getContextPath() %>/monthly-expenses"
              method="get">

            <label for="month"><strong>Select Month:</strong></label>

            <input type="month"
                   id="month"
                   name="month"
                   value="<%= selectedMonth %>"
                   required>

            <button type="submit" class="button">
                View Summary
            </button>
        </form>
    </div>

    <% if (errorMessage != null) { %>

        <div class="card">
            <p class="error-message">
                <%= escapeHtml.apply(errorMessage) %>
            </p>
        </div>

    <% } else { %>

        <!-- Monthly Total -->
        <div class="card total-card">
            <h2><%= escapeHtml.apply(monthLabel) %></h2>

            <p class="total-label">Total spent this month</p>

            <div class="total-value">
                ₹<%= monthlyTotal.setScale(2, RoundingMode.HALF_UP)
                                 .toPlainString() %>
            </div>

            <p>Total expense records: <%= expenses.size() %></p>
        </div>

        <!-- Category-wise Monthly Expenses -->
        <div class="card">
            <h2>Category-wise Expenses</h2>
            <p>Spending breakdown for <%= escapeHtml.apply(monthLabel) %></p>

            <% if (categorySummary.isEmpty()) { %>

                <p class="empty-message">
                    No category expenses found for this month.
                </p>

            <% } else { %>

                <div class="category-grid">

                    <% for (Map.Entry<String, BigDecimal> entry
                            : categorySummary.entrySet()) {

                        String category = entry.getKey() == null
                                ? "Uncategorized"
                                : entry.getKey();

                        BigDecimal amount = entry.getValue() == null
                                ? BigDecimal.ZERO
                                : entry.getValue();

                        double percentage = monthlyTotal.signum() > 0
                                ? amount.multiply(BigDecimal.valueOf(100))
                                        .divide(monthlyTotal, 2,
                                                RoundingMode.HALF_UP)
                                        .doubleValue()
                                : 0.0;

                        percentage = Math.max(0.0,
                                Math.min(100.0, percentage));
                    %>

                        <div class="category-card">

                            <div class="category-name">
                                <%= escapeHtml.apply(category) %>
                            </div>

                            <div class="category-amount">
                                ₹<%= amount.setScale(2, RoundingMode.HALF_UP)
                                           .toPlainString() %>
                            </div>

                            <div class="category-percent">
                                <%= String.format(java.util.Locale.US,
                                        "%.2f", percentage) %>% of monthly spending
                            </div>

                            <div class="progress-track">
                                <div class="progress-bar"
                                     style="width: <%= percentage %>%;">
                                </div>
                            </div>

                        </div>

                    <% } %>

                </div>

            <% } %>
        </div>

        <!-- Individual Expenses Table -->
        <div class="card">
            <h2>Expenses for <%= escapeHtml.apply(monthLabel) %></h2>

            <% if (expenses.isEmpty()) { %>

                <p class="empty-message">
                    No expenses found for this month.
                </p>

            <% } else { %>

                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Amount (₹)</th>
                                <th>Category</th>
                                <th>Date</th>
                                <th>Description</th>
                            </tr>
                        </thead>

                        <tbody>
                            <% for (Expense expense : expenses) { %>
                                <tr>
                                    <td><%= expense.getId() %></td>

                                    <td>
                                        <%= escapeHtml.apply(
                                                expense.getTitle()) %>
                                    </td>

                                    <td class="amount">
                                        ₹<%= expense.getAmount() == null
                                                ? "0.00"
                                                : expense.getAmount()
                                                    .setScale(2,
                                                        RoundingMode.HALF_UP)
                                                    .toPlainString() %>
                                    </td>

                                    <td>
                                        <%= escapeHtml.apply(
                                                expense.getCategory()) %>
                                    </td>

                                    <td>
                                        <%= expense.getExpenseDate() %>
                                    </td>

                                    <td>
                                        <%= escapeHtml.apply(
                                                expense.getDescription()) %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

            <% } %>
        </div>

    <% } %>

</div>

</body>
</html>
