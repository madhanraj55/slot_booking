<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String user = (String) session.getAttribute("username");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contact Us</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(120deg, #89f7fe, #66a6ff);
            color: #fff;
            text-align: center;
            padding: 100px 20px;
        }
        h1 {
            font-size: 40px;
            margin-bottom: 20px;
            text-shadow: 0 2px 8px rgba(0,0,0,0.5);
        }
        p {
            font-size: 18px;
            margin-bottom: 40px;
        }
        .contact-buttons {
            display: flex;
            justify-content: center;
            gap: 30px;
        }
        .contact-btn {
            background: #fff;
            color: #333;
            padding: 15px 30px;
            font-size: 18px;
            border-radius: 30px;
            text-decoration: none;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
        }
        .contact-btn:hover {
            background: #ffd700;
            transform: scale(1.1);
        }
        footer {
            margin-top: 100px;
            font-size: 14px;
            color: #f1f1f1;
        }
    </style>
</head>
<body>
    <h1>Contact Us</h1>
    <p>If you have any queries or want to connect with us, choose an option below:</p>
    <div class="contact-buttons">
        <!-- Gmail Direct Compose -->
        <a class="contact-btn" 
           href="https://mail.google.com/mail/?view=cm&fs=1&to=22ulec305@aaacet.ac.in" 
           target="_blank">
           Send Email
        </a>
        <!-- WhatsApp Direct Chat -->
        <a class="contact-btn" href="https://wa.me/919677676898" target="_blank">
            WhatsApp Us
        </a>
    </div>
    <footer>&copy; 2025 E-Vehicle Portal. All Rights Reserved.</footer>
</body>
</html>
