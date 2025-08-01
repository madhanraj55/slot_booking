<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Selection</title>
    <style>
        body {
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #00c6ff, #0072ff);
            color: white;
        }
        .login-choice {
            text-align: center;
            animation: fadeIn 0.7s ease-out forwards;
        }
        .login-choice h1 {
            font-size: 40px;
            margin-bottom: 50px;
        }
        .login-choice a {
            display: inline-block;
            padding: 15px 40px;
            margin: 20px;
            background: #ffeb3b;
            color: #000;
            text-decoration: none;
            font-size: 20px;
            border-radius: 30px;
            transition: transform 0.3s ease, background 0.3s ease;
        }
        .login-choice a:hover {
            background: #ffc107;
            transform: scale(1.1);
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px) scale(0.95); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
    </style>
</head>
<body>
    <div class="login-choice">
        <h1>Select Login Type</h1>
        <a href="login.jsp">Customer Login</a>
        <a href="adminLogin.jsp">Admin Login</a>
    </div>
</body>
</html>
