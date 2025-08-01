<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String user = (String) session.getAttribute("username");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Handle cancel booking
    String cancelId = request.getParameter("cancelId");
    if (cancelId != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ev_portal", "root", "root");
            PreparedStatement ps = con.prepareStatement(
                "UPDATE bookings SET status='Cancelled' WHERE id=? AND username=?");
            ps.setInt(1, Integer.parseInt(cancelId));
            ps.setString(2, user);
            ps.executeUpdate();
            con.close();
        } catch(Exception e) {
            out.println("<p style='color:red;'>Error cancelling booking: "+e.getMessage()+"</p>");
        }
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ev_portal", "root", "root");
        ps = con.prepareStatement(
            "SELECT id, station, slot_time, cost, status, booking_time FROM bookings WHERE username=? ORDER BY booking_time DESC");
        ps.setString(1, user);
        rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Bookings</title>
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
        h2 {
            text-align: center;
            font-size: 32px;
            margin: 30px 0 20px;
            animation: floatingText 2s ease-in-out infinite alternate;
        }
        table {
            width: 90%;
            margin: auto;
            border-collapse: collapse;
            background: rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(6px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.5);
            border-radius: 12px;
            overflow: hidden;
        }
        th, td {
            padding: 14px;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }
        th {
            background: rgba(0,0,0,0.7);
            color: #ffe600;
            font-size: 18px;
        }
        tr {
            transition: background 0.3s ease, transform 0.2s ease;
        }
        tr:hover {
            background: rgba(255,255,255,0.1);
            transform: scale(1.01);
        }
        .status-active {
            color: #00ff00;
            font-weight: bold;
        }
        .status-cancelled {
            color: rgba(255,0,0,0.7);
            font-weight: bold;
            opacity: 0.7;
        }
        a.cancel-btn {
            padding: 6px 12px;
            background: #d9534f;
            color: #fff;
            border-radius: 4px;
            text-decoration: none;
            transition: background 0.3s ease, transform 0.2s ease;
        }
        a.cancel-btn:hover {
            background: #c9302c;
            transform: scale(1.05);
        }
        .footer-buttons {
            width: 90%;
            margin: 20px auto;
            display: flex;
            justify-content: space-between;
        }
        .footer-buttons a {
            padding: 10px 20px;
            background: #ffe600;
            color: #000;
            text-decoration: none;
            font-weight: bold;
            border-radius: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
        }
        .footer-buttons a:hover {
            background: #ffcc00;
            transform: scale(1.05);
        }

        @keyframes backgroundMove {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        @keyframes floatingText {
            from { transform: translateY(0); }
            to { transform: translateY(-8px); }
        }
    </style>
</head>
<body>
    <h2><i class="fa-solid fa-list"></i> My Bookings</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Station</th>
            <th>Time Slot</th>
            <th>Cost (₹)</th>
            <th>Status</th>
            <th>Booking Time</th>
            <th>Action</th>
        </tr>
        <%
            boolean hasBookings = false;
            while (rs.next()) {
                hasBookings = true;
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("station") %></td>
            <td><%= rs.getString("slot_time") %></td>
            <td>₹<%= rs.getBigDecimal("cost") %></td>
            <td class="<%= rs.getString("status").equals("Cancelled") ? "status-cancelled" : "status-active" %>">
                <%= rs.getString("status") %>
            </td>
            <td><%= rs.getTimestamp("booking_time") %></td>
            <td>
                <% if (!"Cancelled".equals(rs.getString("status"))) { %>
                    <a href="orders.jsp?cancelId=<%= rs.getInt("id") %>" class="cancel-btn">
                        <i class="fa-solid fa-ban"></i> Cancel
                    </a>
                <% } else { %>
                    ---
                <% } %>
            </td>
        </tr>
        <% } if (!hasBookings) { %>
        <tr><td colspan="7" style="text-align:center;color:#ffe600;">No bookings found.</td></tr>
        <% } %>
    </table>

    <div class="footer-buttons">
        <a href="stations.jsp"><i class="fa-solid fa-plus"></i> Book Another Slot</a>
        <a href="home.jsp"><i class="fa-solid fa-home"></i> Back to Home</a>
    </div>
</body>
</html>
<%
    } catch(Exception e) {
        out.println("<p style='color:red;'>Error: "+e.getMessage()+"</p>");
    } finally {
        if(rs!=null) rs.close();
        if(ps!=null) ps.close();
        if(con!=null) con.close();
    }
%>
