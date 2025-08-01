<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String district = request.getParameter("name");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available Stations</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { margin: 0; font-family: 'Segoe UI', sans-serif; background: linear-gradient(270deg,#89f7fe,#66a6ff,#6a11cb,#2575fc);
               background-size: 600% 600%; animation: backgroundMove 15s ease infinite; color: #fff;}
        table { width: 90%; margin: auto; border-collapse: collapse; background: rgba(255,255,255,0.1); border-radius: 12px; overflow: hidden;}
        th, td { padding: 12px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.2); }
        th { background: rgba(0,0,0,0.6); color: #ffe600; }
        td { background: rgba(0,0,0,0.3); }
        button { padding: 8px 15px; border-radius: 5px; background: #ffe600; border: none; font-weight: bold; cursor: pointer; }
        button:hover { background: #ffcc00; }
    </style>
    <script>
        function convertTo24Hour(hour, period) {
            if (period === "PM" && hour < 12) return hour + 12;
            if (period === "AM" && hour === 12) return 0;
            return hour;
        }
        function calculateCost(rowId) {
            const startHour = parseInt(document.getElementById("startHour"+rowId).value);
            const startPeriod = document.getElementById("startPeriod"+rowId).value;
            const endHour = parseInt(document.getElementById("endHour"+rowId).value);
            const endPeriod = document.getElementById("endPeriod"+rowId).value;
            let start = convertTo24Hour(startHour, startPeriod);
            let end = convertTo24Hour(endHour, endPeriod);
            let diff = end - start; if (diff <= 0) diff += 24;
            const cost = diff * 30;
            document.getElementById("cost"+rowId).innerText = "₹" + cost;
            document.getElementById("hiddenCost"+rowId).value = cost;
        }
    </script>
</head>
<body>
<h2 style="text-align:center;color:#ffe600;">Available Stations - <%=district%></h2>
<table>
    <tr>
        <th>Station Name</th><th>Address</th><th>Slots</th><th>Start</th><th>End</th><th>Cost</th><th>Book</th>
    </tr>
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ev_portal","root","root");
        PreparedStatement ps = con.prepareStatement("SELECT id, station_name, address, slots_available FROM ev_stations WHERE district=?");
        ps.setString(1, district);
        ResultSet rs = ps.executeQuery();
        int rowId = 1; boolean hasRecords=false;
        while(rs.next()) { hasRecords=true; %>
    <tr>
        <form action="scanPage.jsp" method="post">
            <td><%=rs.getString("station_name")%></td>
            <td><%=rs.getString("address")%></td>
            <td><%=rs.getInt("slots_available")%></td>
            <td>
                <select name="startHour" id="startHour<%=rowId%>" onchange="calculateCost(<%=rowId%>)">
                    <% for(int h=1; h<=12; h++){ %><option value="<%=h%>"><%=h%></option><% } %>
                </select>
                <select name="startPeriod" id="startPeriod<%=rowId%>" onchange="calculateCost(<%=rowId%>)">
                    <option value="AM">AM</option><option value="PM">PM</option>
                </select>
            </td>
            <td>
                <select name="endHour" id="endHour<%=rowId%>" onchange="calculateCost(<%=rowId%>)">
                    <% for(int h=1; h<=12; h++){ %><option value="<%=h%>"><%=h%></option><% } %>
                </select>
                <select name="endPeriod" id="endPeriod<%=rowId%>" onchange="calculateCost(<%=rowId%>)">
                    <option value="AM">AM</option><option value="PM">PM</option>
                </select>
            </td>
            <td id="cost<%=rowId%>">₹0</td>
            <td>
                <input type="hidden" name="station" value="<%=rs.getString("station_name")%>">
                <input type="hidden" name="address" value="<%=rs.getString("address")%>">
                <input type="hidden" name="cost" id="hiddenCost<%=rowId%>" value="0">
                <button type="submit">Book</button>
            </td>
        </form>
    </tr>
<%  rowId++; } if(!hasRecords){ %>
    <tr><td colspan="7">No stations available</td></tr>
<% } con.close(); }catch(Exception e){ out.println("<tr><td colspan='7'>Error: "+e.getMessage()+"</td></tr>"); } %>
</table>
</body>
</html>
