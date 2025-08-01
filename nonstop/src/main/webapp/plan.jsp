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
    <title>Unlimited Charging Plan</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(270deg, #89f7fe, #66a6ff, #6a11cb, #2575fc);
            background-size: 600% 600%;
            animation: backgroundMove 15s ease infinite;
            color: #fff;
        }
        .plan-container {
            max-width: 800px;
            margin: 100px auto;
            background: rgba(255,255,255,0.1);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.4);
            text-align: center;
            animation: fadeInUp 1s ease-in-out;
            backdrop-filter: blur(5px);
        }
        .plan-container h2 {
            font-size: 36px;
            margin-bottom: 15px;
            color: #ffe600;
        }
        .plan-container p { font-size: 18px; line-height: 1.6; }
        .benefits {
            text-align: left;
            margin-top: 30px;
            padding-left: 20%;
            font-size: 17px;
        }
        .benefits li { margin: 10px 0; }
        .btn-pay {
            display: inline-block;
            margin-top: 30px;
            padding: 12px 25px;
            background: #ffe600;
            color: #000;
            font-size: 18px;
            border-radius: 30px;
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: bold;
        }
        .btn-pay:hover {
            background: #ffcc00;
            box-shadow: 0 0 15px #ffe600;
            transform: scale(1.1);
        }
        /* Animations */
        @keyframes backgroundMove { 
            0% {background-position: 0% 50%;}
            50% {background-position: 100% 50%;}
            100% {background-position: 0% 50%;}
        }
        @keyframes fadeInUp {
            from {opacity: 0; transform: translateY(40px);}
            to {opacity: 1; transform: translateY(0);}
        }
    </style>
</head>
<body>
    <div class="plan-container">
        <h2><i class="fa-solid fa-bolt"></i> Unlimited Charging Pack</h2>
        <p>Enjoy <b>Unlimited EV Charging</b> for just <b>₹999/month</b>.  
        Grab this festive offer and drive without worrying about charging costs!</p>

        <ul class="benefits">
            <li><i class="fa-solid fa-check"></i> Unlimited charging sessions</li>
            <li><i class="fa-solid fa-check"></i> Priority slot booking</li>
            <li><i class="fa-solid fa-check"></i> 24/7 customer support</li>
            <li><i class="fa-solid fa-check"></i> Free battery check up !</li>
        </ul>

        <a href="#" class="btn-pay">Pay ₹999 & Activate</a>
    </div>
</body>
</html>
