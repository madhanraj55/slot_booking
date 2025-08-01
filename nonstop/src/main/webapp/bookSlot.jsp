<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String user = (String) session.getAttribute("username");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get values from previous page
    String stationId = request.getParameter("stationId");
    String startHour = request.getParameter("startHour");
    String startPeriod = request.getParameter("startPeriod");
    String endHour = request.getParameter("endHour");
    String endPeriod = request.getParameter("endPeriod");
    String cost = request.getParameter("cost");

    String stationName = "", address = "";
    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ev_portal", "root", "root");

        ps = con.prepareStatement("SELECT station_name, address FROM ev_stations WHERE id=?");
        ps.setInt(1, Integer.parseInt(stationId));
        rs = ps.executeQuery();
        if(rs.next()){
            stationName = rs.getString("station_name");
            address = rs.getString("address");
        }
    } catch(Exception e){
        out.println("<h3 style='color:red;'>Error: "+e.getMessage()+"</h3>");
    } finally {
        if(rs!=null) rs.close();
        if(ps!=null) ps.close();
        if(con!=null) con.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Summary</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 30px; }
        .card { 
            display: inline-block; border: 1px solid #ccc; padding: 20px; border-radius: 8px;
            background: #f8f8f8; box-shadow: 0 2px 8px rgba(0,0,0,0.2); width: 400px;
        }
        h2 { margin-bottom: 15px; }
        p { font-size: 18px; margin: 8px 0; }
        .btn { padding: 10px 15px; border-radius: 5px; font-size: 16px;
               text-decoration: none; color: white; background-color: #0f9d58; }
        .btn:hover { background-color: #0c7a43; }
        .cancel-btn { background-color: #6c757d; margin-left: 10px; }
        .cancel-btn:hover { background-color: #5a6268; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Booking Summary</h2>
        <p><b>Station:</b> <%=stationName%></p>
        <p><b>Address:</b> <%=address%></p>
        <p><b>Start Time:</b> <%=startHour%> <%=startPeriod%></p>
        <p><b>End Time:</b> <%=endHour%> <%=endPeriod%></p>
        <p><b>Total Cost:</b> ₹<%=cost%></p>

        <form action="scanPage.jsp" method="post" style="margin-top:20px;">
            <input type="hidden" name="stationId" value="<%=stationId%>">
            <input type="hidden" name="station" value="<%=stationName%>">
            <input type="hidden" name="address" value="<%=address%>">
            <input type="hidden" name="slotTime" value="<%=startHour%> <%=startPeriod%> - <%=endHour%> <%=endPeriod%>">
            <input type="hidden" name="cost" value="<%=cost%>">
            <button type="submit" class="btn">Proceed to Pay</button>
            <a href="availableStations.jsp" class="btn cancel-btn">Cancel</a>
        </form>
    </div>
</body>
</html>
