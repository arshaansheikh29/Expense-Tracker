<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.expensetracker.util.Expense" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Expenses - Expense Tracker</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f7fb;
            margin: 0;
            padding: 30px;
            color: #263238;
        }

        .container {
            max-width: 1100px;
            margin: 40px auto 0;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 12px #0001;
            overflow-x: auto;
        }

        h1 {
            color: #2874d0;
            text-align: center;
        }

        .search-panel {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: center;
            margin: 25px 0 15px;
        }

        .search-panel input,
        .search-panel select {
            flex: 1;
            min-width: 180px;
            padding: 11px 12px;
            border: 1px solid #ccd5df;
            border-radius: 6px;
            font-size: 14px;
            background: white;
        }

        .button {
            display: inline-block;
            padding: 8px 12px;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 5px;
            white-space: nowrap;
            cursor: pointer;
            font-size: 14px;
        }

        .back-button {
            background: #555;
            padding: 10px 16px;
        }

        .search-button {
            background: #2874d0;
            padding: 11px 16px;
        }

        .clear-button {
            background: #607d8b;
            padding: 11px 16px;
        }

        .edit-button {
            background: #1769aa;
        }

        .delete-button {
            background: #dc3545;
        }

        .button:hover {
            opacity: 0.88;
        }

        .results-info {
            color: #607d8b;
            margin: 12px 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background: #2874d0;
            color: white;
        }

        tbody tr:nth-child(even) {
            background: #f2f6fc;
        }

        tbody tr:hover {
            background: #eaf2fc;
        }

        .actions {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .delete-form {
            display: inline;
            margin: 0;
        }

        .empty {
            text-align: center;
            padding: 20px;
            color: #607d8b;
        }

        .hidden-row {
            display: none;
        }

        @media (max-width: 600px) {
            body {
                padding: 15px;
            }

            .container {
                margin-top: 50px;
                padding: 15px;
            }

            .search-panel {
                flex-direction: column;
                align-items: stretch;
            }

            .search-panel input,
            .search-panel select {
                box-sizing: border-box;
                width: 100%;
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

    <h1>My Expenses</h1>

    <%
        List<Expense> expenses =
            (List<Expense>) request.getAttribute("expenses");
    %>

    <% if (expenses != null && !expenses.isEmpty()) { %>

        <div class="search-panel">
            <input
                type="text"
                id="searchTitle"
                placeholder="Search by expense title..."
                aria-label="Search by expense title">

            <select id="categoryFilter" aria-label="Filter by category">
                <option value="">All Categories</option>

                <%
                    java.util.Set<String> categories =
                        new java.util.TreeSet<>(
                            String.CASE_INSENSITIVE_ORDER
                        );

                    for (Expense expense : expenses) {
                        if (expense.getCategory() != null
                                && !expense.getCategory().trim().isEmpty()) {
                            categories.add(expense.getCategory().trim());
                        }
                    }

                    for (String category : categories) {
                %>
                    <option value="<%= category.replace("&", "&amp;")
                        .replace("\"", "&quot;")
                        .replace("<", "&lt;")
                        .replace(">", "&gt;") %>"><%= category.replace("&", "&amp;")
                        .replace("<", "&lt;")
                        .replace(">", "&gt;") %></option>
                <% } %>
            </select>

            <button type="button" class="button search-button"
                    onclick="filterExpenses()">
                Search
            </button>

            <button type="button" class="button clear-button"
                    onclick="clearSearch()">
                Clear
            </button>
        </div>

        <p class="results-info" id="resultsInfo" aria-live="polite"></p>

        <table id="expensesTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Amount (₹)</th>
                    <th>Category</th>
                    <th>Date</th>
                    <th>Description</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody>
                <% for (Expense expense : expenses) { %>
                    <tr class="expense-row"
                        data-title="<%= expense.getTitle() == null ? "" :
                            expense.getTitle().replace("&", "&amp;")
                                .replace("\"", "&quot;")
                                .replace("<", "&lt;")
                                .replace(">", "&gt;") %>"
                        data-category="<%= expense.getCategory() == null ? "" :
                            expense.getCategory().replace("&", "&amp;")
                                .replace("\"", "&quot;")
                                .replace("<", "&lt;")
                                .replace(">", "&gt;") %>">

                        <td><%= expense.getId() %></td>

                        <td><%= expense.getTitle() == null ? "" :
                            expense.getTitle().replace("&", "&amp;")
                                .replace("<", "&lt;")
                                .replace(">", "&gt;") %></td>

                        <td>₹<%= expense.getAmount() %></td>

                        <td><%= expense.getCategory() == null ? "" :
                            expense.getCategory().replace("&", "&amp;")
                                .replace("<", "&lt;")
                                .replace(">", "&gt;") %></td>

                        <td><%= expense.getExpenseDate() %></td>

                        <td><%= expense.getDescription() == null ? "" :
                            expense.getDescription().replace("&", "&amp;")
                                .replace("<", "&lt;")
                                .replace(">", "&gt;") %></td>

                        <td>
                            <div class="actions">

                                <a class="button edit-button"
                                   href="<%= request.getContextPath() %>/edit-expense?id=<%= expense.getId() %>">
                                    Edit
                                </a>

                                <form class="delete-form"
                                      action="<%= request.getContextPath() %>/delete-expense"
                                      method="post"
                                      onsubmit="return confirm('Are you sure you want to delete this expense? This action cannot be undone.');">

                                    <input type="hidden" name="id"
                                           value="<%= expense.getId() %>">

                                    <button type="submit"
                                            class="button delete-button">
                                        Delete
                                    </button>
                                </form>

                            </div>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>

        <p class="empty" id="noResults" style="display: none;">
            No expenses match your search. Try another title or category.
        </p>

    <% } else { %>

        <p class="empty">No expenses found. Add an expense to get started.</p>

    <% } %>

</div>

<script>
    function filterExpenses() {
        const titleInput = document.getElementById("searchTitle");
        const categorySelect = document.getElementById("categoryFilter");

        if (!titleInput || !categorySelect) {
            return;
        }

        const searchTitle = titleInput.value.trim().toLowerCase();
        const selectedCategory = categorySelect.value.toLowerCase();

        const rows = document.querySelectorAll(".expense-row");
        let visibleCount = 0;

        rows.forEach(function(row) {
            const title = (row.dataset.title || "").toLowerCase();
            const category = (row.dataset.category || "").toLowerCase();

            const titleMatches = title.includes(searchTitle);
            const categoryMatches =
                selectedCategory === "" || category === selectedCategory;

            const matches = titleMatches && categoryMatches;

            row.classList.toggle("hidden-row", !matches);

            if (matches) {
                visibleCount++;
            }
        });

        const noResults = document.getElementById("noResults");
        const resultsInfo = document.getElementById("resultsInfo");

        noResults.style.display = visibleCount === 0 ? "block" : "none";
        resultsInfo.textContent =
            "Showing " + visibleCount + " of " + rows.length + " expenses.";
    }

    function clearSearch() {
        document.getElementById("searchTitle").value = "";
        document.getElementById("categoryFilter").value = "";
        filterExpenses();
    }

    document.addEventListener("DOMContentLoaded", function() {
        const titleInput = document.getElementById("searchTitle");
        const categorySelect = document.getElementById("categoryFilter");

        if (titleInput) {
            titleInput.addEventListener("input", filterExpenses);
        }

        if (categorySelect) {
            categorySelect.addEventListener("change", filterExpenses);
        }

        filterExpenses();
    });
</script>

</body>
</html>
