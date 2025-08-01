<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Registration</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(270deg, #1e3c72, #2a5298, #6dd5ed, #2193b0);
            background-size: 600% 600%;
            animation: gradientBG 15s ease infinite;
            color: #fff;
        }
        h2 {
            text-align: center;
            margin-top: 40px;
            font-size: 32px;
            text-shadow: 0 0 10px #00ffff, 0 0 20px #00ffff;
            animation: textGlow 2s infinite alternate;
        }
        form {
            width: 400px;
            margin: 50px auto;
            background: rgba(0, 0, 0, 0.6);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 4px 15px rgba(0,0,0,0.5);
            animation: fadeInUp 1.5s ease;
        }
        table { width: 100%; }
        table td { padding: 12px 0; font-size: 16px; }
        input[type="text"], input[type="password"], input[type="email"] {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 8px;
            outline: none;
            font-size: 14px;
            transition: box-shadow 0.3s ease;
        }
        input[type="text"]:focus,
        input[type="password"]:focus,
        input[type="email"]:focus {
            box-shadow: 0 0 8px #00ffff;
        }
        input[type="submit"] {
            width: 100%;
            padding: 12px;
            margin-top: 15px;
            background: linear-gradient(45deg, #00c6ff, #0072ff);
            border: none;
            border-radius: 8px;
            color: white;
            font-size: 16px;
            cursor: pointer;
            font-weight: bold;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        input[type="submit"]:hover {
            transform: scale(1.05);
            box-shadow: 0px 0px 15px #00ffff;
        }
        .login-link {
            display: block;
            margin-top: 15px;
            text-align: center;
            font-size: 14px;
        }
        .login-link a {
            color: #ffeb3b;
            text-decoration: none;
            font-weight: bold;
        }
        .login-link a:hover { text-decoration: underline; }
        @keyframes gradientBG {
            0% {background-position: 0% 50%;}
            50% {background-position: 100% 50%;}
            100% {background-position: 0% 50%;}
        }
        @keyframes fadeInUp {
            from {opacity: 0; transform: translateY(40px);}
            to {opacity: 1; transform: translateY(0);}
        }
        @keyframes textGlow {
            from {text-shadow: 0 0 10px #00ffff, 0 0 20px #00ffff;}
            to {text-shadow: 0 0 20px #00e6e6, 0 0 40px #00e6e6;}
        }
    </style>
</head>
<body>
    <h2>Register New Customer</h2>
    <form action="employee?action=INSERT" method="post">
        <table>
            <tr><td>First Name:</td><td><input type="text" name="firstName" required></td></tr>
            <tr><td>Last Name:</td><td><input type="text" name="lastName" required></td></tr>
            <tr><td>Username:</td><td><input type="text" name="username" required></td></tr>
            <tr><td>Password:</td><td><input type="password" name="password" required></td></tr>
            <tr><td>Email:</td><td><input type="email" name="email" required></td></tr>
            <tr><td colspan="2"><input type="submit" value="Register"></td></tr>
        </table>
        <div class="login-link">
            Already have an account? <a href="login.jsp"> Login</a>
        </div>
    </form>
</body>
</html>
