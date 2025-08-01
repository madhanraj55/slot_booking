<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder, java.sql.*" %>
<%
    // --- Check Login ---
    String user = (String)session.getAttribute("username");
    if(user == null){
        // store booking details temporarily if login is required
        session.setAttribute("pendingStation", request.getParameter("station"));
        session.setAttribute("pendingStartHour", request.getParameter("startHour"));
        session.setAttribute("pendingStartPeriod", request.getParameter("startPeriod"));
        session.setAttribute("pendingEndHour", request.getParameter("endHour"));
        session.setAttribute("pendingEndPeriod", request.getParameter("endPeriod"));
        session.setAttribute("pendingCost", request.getParameter("cost"));
        response.sendRedirect("login.jsp");
        return;
    }

    // --- Get booking details (either from request or session) ---
    String station = request.getParameter("station");
    String startHour = request.getParameter("startHour");
    String startPeriod = request.getParameter("startPeriod");
    String endHour = request.getParameter("endHour");
    String endPeriod = request.getParameter("endPeriod");
    String costParam = request.getParameter("cost");

    // If station is null, use session (user came here after login)
    if (station == null || station.trim().equals("")) {
        station = (String)session.getAttribute("pendingStation");
        startHour = (String)session.getAttribute("pendingStartHour");
        startPeriod = (String)session.getAttribute("pendingStartPeriod");
        endHour = (String)session.getAttribute("pendingEndHour");
        endPeriod = (String)session.getAttribute("pendingEndPeriod");
        costParam = (String)session.getAttribute("pendingCost");

        // clear session data
        session.removeAttribute("pendingStation");
        session.removeAttribute("pendingStartHour");
        session.removeAttribute("pendingStartPeriod");
        session.removeAttribute("pendingEndHour");
        session.removeAttribute("pendingEndPeriod");
        session.removeAttribute("pendingCost");
    }

    int cost = 0;
    if(costParam != null && !costParam.trim().equals("") && !costParam.equals("null")){
        cost = Integer.parseInt(costParam);
    }

    String slotTime = (startHour != null ? startHour : "--") + " " + 
                      (startPeriod != null ? startPeriod : "--") + " - " + 
                      (endHour != null ? endHour : "--") + " " + 
                      (endPeriod != null ? endPeriod : "--");

    // --- Insert booking into DB ---
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ev_portal", "root", "root");
        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO bookings(username, station, slot_time, cost, status) VALUES(?,?,?,?,?)");
        ps.setString(1, user);
        ps.setString(2, station);
        ps.setString(3, slotTime);
        ps.setDouble(4, cost);
        ps.setString(5, "Active");
        ps.executeUpdate();
        con.close();
    } catch(Exception e) {
        out.println("<p style='color:red;'>Error inserting booking: "+e.getMessage()+"</p>");
    }

    // --- Generate UPI QR ---
    String upiId = "madhanrajanthony-1@okaxis";
    String payeeName = "EV Charging";
    String upiUrl = "upi://pay?pa="+upiId+"&pn="+payeeName+"&am="+cost+"&cu=INR";
    String encodedUpiUrl = URLEncoder.encode(upiUrl, "UTF-8");
    String qrUrl = "https://quickchart.io/qr?text="+encodedUpiUrl+"&size=250";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Scan & Pay</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(270deg, #89f7fe, #66a6ff, #6a11cb, #2575fc);
            background-size: 600% 600%;
            animation: backgroundMove 15s ease infinite;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            color: #fff;
        }
        .card {
            width: 400px;
            padding: 30px;
            border-radius: 12px;
            background: rgba(0,0,0,0.6);
            backdrop-filter: blur(8px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.5);
            text-align: center;
            animation: fadeInUp 1s ease-in-out;
        }
        .card h2 {
            margin-bottom: 15px;
            font-size: 28px;
            animation: floatingText 2s ease-in-out infinite alternate;
            color: #ffe600;
        }
        .card p { font-size: 18px; margin: 8px 0; }
        .qr img {
            margin-top: 20px;
            border: 3px solid #fff;
            border-radius: 12px;
            padding: 10px;
            background: #fff;
            transition: transform 0.3s ease;
        }
        .qr img:hover { transform: scale(1.05); }
        .btn-container { margin-top: 25px; }
        .btn {
            padding: 12px 20px;
            border-radius: 25px;
            color: #000;
            text-decoration: none;
            background: #ffe600;
            font-weight: bold;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
        }
        .btn:hover { background: #ffcc00; transform: scale(1.05); }

        @keyframes backgroundMove {
            0% {background-position: 0% 50%;}
            50% {background-position: 100% 50%;}
            100% {background-position: 0% 50%;}
        }
        @keyframes fadeInUp {
            from {opacity: 0; transform: translateY(40px);}
            to {opacity: 1; transform: translateY(0);}
        }
        @keyframes floatingText {
            from {transform: translateY(0);}
            to {transform: translateY(-8px);}
        }
    </style>
</head>
<body>
    <div class="card">
        <h2><i class="fa-solid fa-qrcode"></i> Booking Details</h2>
        <p><b>Station:</b> <%=station%></p>
        <p><b>Time:</b> <%=slotTime%></p>
        <p><b>Total Cost:</b> ₹<%=cost%></p>
        <div class="qr">
            <p>Scan with Google Pay or any UPI app</p>
            <img src="<%=qrUrl%>" alt="QR Code">
        </div>
        <div class="btn-container">
            <a href="orders.jsp" class="btn"><i class="fa-solid fa-check"></i> Paid</a>
        </div>
    </div>
</body>
</html>
