<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Expense - Expense Tracker</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f1f5f9;
            margin: 0;
            padding: 40px 16px;
        }

        .container {
            max-width: 500px;
            margin: auto;
            background: white;
            padding: 28px;
            border-radius: 12px;
        }

        h1 { color: #2563eb; text-align: center; }

        label {
            display: block;
            margin-top: 16px;
            font-weight: bold;
        }

        input, select, textarea {
            width: 100%;
            box-sizing: border-box;
            padding: 10px;
            margin-top: 6px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
        }

        button {
            width: 100%;
            margin-top: 22px;
            padding: 12px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover { background: #1d4ed8; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Add Expense</h1>

        <form action="add-expense" method="post">
            <label for="title">Expense Title</label>
            <input type="text" id="title" name="title" required maxlength="100">

            <label for="amount">Amount (₹)</label>
            <input type="number" id="amount" name="amount"
                   min="0.01" step="0.01" required>

            <label for="category">Category</label>
            <select id="category" name="category" required>
                <option value="">Select category</option>
                <option>Food</option>
                <option>Travel</option>
                <option>Shopping</option>
                <option>Bills</option>
                <option>Education</option>
                <option>Other</option>
            </select>

            <label for="expenseDate">Date</label>
            <input type="date" id="expenseDate" name="expenseDate" required>

            <label for="description">Description</label>
            <textarea id="description" name="description"
                      rows="3" maxlength="255"></textarea>

            <button type="submit">Save Expense</button>
        </form>
    </div>
</body>
</html>
