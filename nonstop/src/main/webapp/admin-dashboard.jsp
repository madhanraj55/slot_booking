<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    String search = request.getParameter("search") != null ? request.getParameter("search") : "";
    String statusFilter = request.getParameter("statusFilter");
    String export = request.getParameter("export");
    String cancelId = request.getParameter("cancelId");

    // Sorting parameters
    String sortBy = request.getParameter("sortBy") != null ? request.getParameter("sortBy") : "b.id";
    String sortOrder = request.getParameter("sortOrder") != null ? request.getParameter("sortOrder") : "DESC";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ev_portal", "root", "root");

        // Cancel booking
        if (cancelId != null) {
            PreparedStatement cancelPs = conn.prepareStatement("UPDATE bookings SET status='Cancelled' WHERE id=?");
            cancelPs.setInt(1, Integer.parseInt(cancelId));
            cancelPs.executeUpdate();
            cancelPs.close();
        }

        // Build SQL with filters and sorting
        StringBuilder sqlBuilder = new StringBuilder(
            "SELECT b.id, b.username, u.email, b.station, b.slot_time, b.cost, b.booking_time, b.status " +
            "FROM bookings b LEFT JOIN users u ON b.username=u.username " +
            "WHERE CONCAT(b.username, IFNULL(u.email,'')) LIKE ? "
        );
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sqlBuilder.append("AND b.status = ? ");
        }
        sqlBuilder.append("ORDER BY ").append(sortBy).append(" ").append(sortOrder);

        ps = conn.prepareStatement(sqlBuilder.toString());
        ps.setString(1, "%" + search + "%");
        int paramIndex = 2;
        if (statusFilter != null && !statusFilter.isEmpty()) {
            ps.setString(paramIndex++, statusFilter);
        }
        rs = ps.executeQuery();

        // Export Excel
        if ("1".equals(export)) {
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment;filename=Bookings.xls");
            out.println("BookingID\tUsername\tEmail\tStation\tSlotTime\tCost\tBookingTime\tStatus");
            while (rs.next()) {
                out.println(rs.getInt("id") + "\t" +
                            rs.getString("username") + "\t" +
                            rs.getString("email") + "\t" +
                            rs.getString("station") + "\t" +
                            rs.getString("slot_time") + "\t" +
                            rs.getBigDecimal("cost") + "\t" +
                            rs.getTimestamp("booking_time") + "\t" +
                            rs.getString("status"));
            }
            rs.close(); ps.close(); conn.close();
            return;
        }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {margin:0;font-family:'Segoe UI',sans-serif;background:linear-gradient(270deg,#89f7fe,#66a6ff,#6a11cb,#2575fc);
            background-size:600% 600%;animation:bgMove 15s ease infinite;color:#fff;}
        header {background:rgba(0,0,0,0.7);padding:20px 40px;display:flex;justify-content:space-between;align-items:center;
            box-shadow:0 4px 15px rgba(0,0,0,0.4);}
        header h1 {font-size:26px;margin:0;color:#ffe600;}
        .logout {color:#fff;text-decoration:none;font-weight:bold;transition:color .3s ease;}
        .logout:hover {color:#ffe600;}
        main {padding:40px;display:flex;flex-direction:column;align-items:center;}
        h2 {font-size:28px;animation:floatText 2s ease-in-out infinite alternate;margin-bottom:30px;}
        .search-form {margin-bottom:30px;}
        .search-form input,.search-form select {padding:10px;margin:5px;border-radius:25px;border:none;outline:none;
            box-shadow:0 2px 5px rgba(0,0,0,0.3);}
        .search-form button {padding:10px 20px;border:none;margin:5px;border-radius:25px;background:#ffe600;font-weight:bold;
            cursor:pointer;transition:transform 0.2s ease;}
        .search-form button:hover {transform:scale(1.05);}
        .table-container {background:rgba(0,0,0,0.5);border-radius:12px;padding:20px;backdrop-filter:blur(8px);
            box-shadow:0 8px 20px rgba(0,0,0,0.5);width:100%;max-width:1100px;overflow-x:auto;}
        table {width:100%;border-collapse:collapse;color:#fff;}
        th,td {padding:12px;border-bottom:1px solid rgba(255,255,255,0.2);text-align:center;}
        th {background:rgba(0,0,0,0.7);color:#fff;cursor:pointer;}
        th:hover {text-decoration:underline;}
        tr:nth-child(even){background:rgba(255,255,255,0.05);}
        .cancel-btn {padding:5px 12px;border-radius:5px;background:#d9534f;text-decoration:none;color:#fff;transition:background .3s ease;}
        .cancel-btn:hover {background:#c9302c;}
        footer {margin-top:50px;padding:20px;background:rgba(0,0,0,0.7);text-align:center;}
        @keyframes bgMove {0%{background-position:0% 50%;}50%{background-position:100% 50%;}100%{background-position:0% 50%;}}
        @keyframes floatText {from{transform:translateY(0);}to{transform:translateY(-8px);}}

        /* Ensure sorting links remain white */
        th a { color: #fff !important; text-decoration: none; }
        th a:hover { text-decoration: underline; }

        /* Specific columns white color */
        td:nth-child(1),  /* Booking ID */
        td:nth-child(6),  /* Cost */
        td:nth-child(7),  /* Booking Time */
        td:nth-child(8)   /* Status */
        { color: #fff !important; }
    </style>
</head>
<body>
<header>
    <h1><i class="fa-solid fa-bolt"></i> Admin Dashboard</h1>
    <a class="logout" href="logout.jsp"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
</header>
<main>
    <h2>Welcome, <%= adminName %></h2>
    <form class="search-form" method="get">
        <input type="text" name="search" placeholder="Search by username or email" value="<%= search %>">
        <select name="statusFilter">
            <option value="" <%= (statusFilter==null||statusFilter.isEmpty())?"selected":"" %>>All</option>
            <option value="Active" <%= "Active".equals(statusFilter)?"selected":"" %>>Active</option>
            <option value="Cancelled" <%= "Cancelled".equals(statusFilter)?"selected":"" %>>Cancelled</option>
        </select>
        <button type="submit"><i class="fa-solid fa-search"></i> Search</button>
        <button type="submit" name="export" value="1"><i class="fa-solid fa-file-excel"></i> Export</button>
    </form>

    <div class="table-container">
        <table>
            <tr>
                <th><a href="?sortBy=b.id&sortOrder=<%= "b.id".equals(sortBy)&&"ASC".equals(sortOrder)?"DESC":"ASC" %>&search=<%= search %>&statusFilter=<%= statusFilter %>">Booking ID</a></th>
                <th>Username</th>
                <th>Email</th>
                <th>Station</th>
                <th>Slot Time</th>
                <th><a href="?sortBy=b.cost&sortOrder=<%= "b.cost".equals(sortBy)&&"ASC".equals(sortOrder)?"DESC":"ASC" %>&search=<%= search %>&statusFilter=<%= statusFilter %>">Cost (₹)</a></th>
                <th><a href="?sortBy=b.booking_time&sortOrder=<%= "b.booking_time".equals(sortBy)&&"ASC".equals(sortOrder)?"DESC":"ASC" %>&search=<%= search %>&statusFilter=<%= statusFilter %>">Booking Time</a></th>
                <th><a href="?sortBy=b.status&sortOrder=<%= "b.status".equals(sortBy)&&"ASC".equals(sortOrder)?"DESC":"ASC" %>&search=<%= search %>&statusFilter=<%= statusFilter %>">Status</a></th>
                <th>Action</th>
            </tr>
            <%
                boolean dataFound=false;
                while(rs.next()){ dataFound=true; %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("email") != null ? rs.getString("email") : "-" %></td>
                <td><%= rs.getString("station") %></td>
                <td><%= rs.getString("slot_time") %></td>
                <td>₹<%= rs.getBigDecimal("cost") %></td>
                <td><%= rs.getTimestamp("booking_time") %></td>
                <td><%= rs.getString("status") %></td>
                <td>
                    <% if(!"Cancelled".equalsIgnoreCase(rs.getString("status"))) { %>
                        <a href="adminDashboard.jsp?cancelId=<%= rs.getInt("id") %>&search=<%= search %>&statusFilter=<%= statusFilter %>"
                           class="cancel-btn" onclick="return confirm('Are you sure you want to cancel this booking?');">Cancel</a>
                    <% } else { %> --- <% } %>
                </td>
            </tr>
            <% } if(!dataFound){ %><tr><td colspan="9">No Data Found</td></tr><% } %>
        </table>
    </div>
</main>
<footer>&copy; 2025 E-Vehicle Portal. All Rights Reserved.</footer>
</body>
</html>
<%
    } catch(Exception e) {
        out.println("<p style='color:red;'>Error: "+e.getMessage()+"</p>");
    } finally {
        if(rs!=null) rs.close();
        if(ps!=null) ps.close();
        if(conn!=null) conn.close();
    }
%>
