<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login - E-Vehicle Portal</title>
    <style>
        body { 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh; 
            background: linear-gradient(120deg, #667db6, #0082c8, #0082c8, #667db6); 
            font-family: sans-serif; 
        }
        .login-box {
            background: rgba(255,255,255,0.1);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            text-align: center;
            width: 300px;
        }
        .login-box h2 {
            margin-bottom: 20px;
            color: #fff;
            text-shadow: 0 0 10px #000;
        }
        input[type=text], input[type=password] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: none;
            border-radius: 8px;
        }
        button {
            padding: 10px 30px;
            background: #ffeb3b;
            border: none;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            border-radius: 8px;
            transition: 0.3s;
            width: 100%;
        }
        button:hover {
            background: #ffc107;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Admin Login</h2>
        <!-- IMPORTANT: changed action -->
        <form action="AdminLoginServlet" method="post">
            <input type="text" name="username" placeholder="Admin Username" required><br>
            <input type="password" name="password" placeholder="Password" required><br>
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>
