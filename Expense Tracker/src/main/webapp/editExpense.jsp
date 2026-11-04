<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="com.expensetracker.util.Expense" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Expense expense = (Expense) request.getAttribute("expense");

    if (expense == null) {
        response.sendRedirect(request.getContextPath() + "/view-expenses");
        return;
    }

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Expense - Expense Tracker</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f3f6fa;
            margin: 0;
            padding: 30px;
        }

        .container {
            max-width: 500px;
            margin: 40px auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px #0002;
        }

        h2 {
            text-align: center;
            color: #1769aa;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        input, select, textarea {
            box-sizing: border-box;
            width: 100%;
            padding: 11px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        textarea {
            resize: vertical;
        }

        button, .back {
            display: inline-block;
            padding: 11px 18px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            cursor: pointer;
            margin-top: 20px;
        }

        button {
            background: #1769aa;
            color: white;
        }

        .back {
            background: #555;
            color: white;
        }
    </style>
</head>

<body>

<div class="container">
    <h2>Edit Expense</h2>

    <form action="<%= request.getContextPath() %>/update-expense"
          method="post">

        <input type="hidden" name="id"
               value="<%= expense.getId() %>">

        <label for="title">Title</label>
        <input type="text" id="title" name="title"
               value="<%= expense.getTitle() %>" required>

        <label for="amount">Amount (₹)</label>
        <input type="number" id="amount" name="amount"
               min="0.01" step="0.01"
               value="<%= expense.getAmount() %>" required>

        <label for="category">Category</label>
        <select id="category" name="category" required>
            <option value="Food"
                <%= "Food".equals(expense.getCategory()) ? "selected" : "" %>>
                Food
            </option>
            <option value="Travel"
                <%= "Travel".equals(expense.getCategory()) ? "selected" : "" %>>
                Travel
            </option>
            <option value="Shopping"
                <%= "Shopping".equals(expense.getCategory()) ? "selected" : "" %>>
                Shopping
            </option>
            <option value="Bills"
                <%= "Bills".equals(expense.getCategory()) ? "selected" : "" %>>
                Bills
            </option>
            <option value="Other"
                <%= "Other".equals(expense.getCategory()) ? "selected" : "" %>>
                Other
            </option>
        </select>

        <label for="expenseDate">Date</label>
        <input type="date" id="expenseDate" name="expenseDate"
               value="<%= dateFormat.format(expense.getExpenseDate()) %>"
               required>

        <label for="description">Description</label>
        <textarea id="description" name="description"
                  rows="3"><%= expense.getDescription() == null
                    ? "" : expense.getDescription() %></textarea>

        <button type="submit">Save Changes</button>

        <a class="back"
           href="<%= request.getContextPath() %>/view-expenses">
            Cancel
        </a>
    </form>
</div>

</body>
</html>
