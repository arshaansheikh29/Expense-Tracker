<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Expense Tracker</title>
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
    </style>
</head>
<body>
<div class="container">
    <h2>Create Account</h2>

    <% if ("empty".equals(request.getParameter("error"))) { %>
        <p class="error">Please fill in all fields.</p>
    <% } else if ("duplicate".equals(request.getParameter("error"))) { %>
        <p class="error">This email is already registered.</p>
    <% } else if ("failed".equals(request.getParameter("error"))) { %>
        <p class="error">Registration failed. Please try again.</p>
    <% } %>

    <form action="register" method="post">
        <input type="text" name="name"
               placeholder="Full Name" required>

        <input type="email" name="email"
               placeholder="Email Address" required>

        <input type="password" name="password"
               placeholder="Password" required minlength="8">

        <button type="submit">Register</button>
    </form>

    <p>Already registered?
        <a href="login.jsp">Login here</a>
    </p>
</div>
</body>
</html>
