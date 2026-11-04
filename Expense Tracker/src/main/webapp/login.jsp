<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Expense Tracker</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f3f6fa;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .container {
            background: white;
            padding: 30px;
            width: 350px;
            border-radius: 10px;
            box-shadow: 0 4px 15px #0002;
        }
        h2 { text-align: center; color: #1769aa; }
        input {
            box-sizing: border-box;
            width: 100%;
            padding: 11px;
            margin: 9px 0;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #1769aa;
            color: white;
            border: none;
            cursor: pointer;
        }
        .error { color: #c62828; }
        .success { color: #218838; }
    </style>
</head>
<body>
<div class="container">
    <h2>Login</h2>

    <% if ("1".equals(request.getParameter("registered"))) { %>
        <p class="success">Registration successful! Please log in.</p>
    <% } %>

    <% if ("invalid".equals(request.getParameter("error"))) { %>
        <p class="error">Invalid email or password.</p>
    <% } %>

    <form action="login" method="post">
        <input type="email" name="email"
               placeholder="Email Address" required>

        <input type="password" name="password"
               placeholder="Password" required>

        <button type="submit">Login</button>
    </form>

    <p>Don't have an account?
        <a href="register.jsp">Register here</a>
    </p>
</div>
</body>
</html>
