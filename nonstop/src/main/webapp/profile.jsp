<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = "";
    String firstName = "";
    String lastName = "";
    String email = "";

    // ✅ Use correct database (ev_portal)
    String url = "jdbc:mysql://localhost:3306/ev_portal";
    String dbUser = "root";
    String dbPass = "root";
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(url, dbUser, dbPass);

    // ✅ Handle POST request
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        firstName = request.getParameter("first_name");
        lastName = request.getParameter("last_name");
        email = request.getParameter("email");
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");

        // Update profile (without password)
        PreparedStatement update = con.prepareStatement(
            "UPDATE users SET first_name=?, last_name=?, email=? WHERE username=?"
        );
        update.setString(1, firstName);
        update.setString(2, lastName);
        update.setString(3, email);
        update.setString(4, username);
        update.executeUpdate();
        update.close();

        // Update password only if given and matches
        if (newPassword != null && !newPassword.isEmpty()) {
            if (newPassword.equals(confirmPassword)) {
                PreparedStatement updatePass = con.prepareStatement(
                    "UPDATE users SET password=? WHERE username=?"
                );
                updatePass.setString(1, newPassword);
                updatePass.setString(2, username);
                updatePass.executeUpdate();
                updatePass.close();
                message = "Profile and password updated successfully!";
            } else {
                message = "Password and Confirm Password do not match!";
            }
        } else {
            message = "Profile updated successfully!";
        }
    }

    // Fetch current data
    PreparedStatement pst = con.prepareStatement(
        "SELECT first_name, last_name, email FROM users WHERE username=?"
    );
    pst.setString(1, username);
    ResultSet rs = pst.executeQuery();
    if(rs.next()) {
        firstName = rs.getString("first_name");
        lastName = rs.getString("last_name");
        email = rs.getString("email");
    }
    rs.close();
    pst.close();
    con.close();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile</title>
    <style>
        body { font-family: Arial, sans-serif; background: linear-gradient(120deg,#00c6ff,#0072ff); color:white; margin:0; padding:0; }
        .container { width:50%; margin:100px auto; background:rgba(0,0,0,0.5); padding:40px; border-radius:10px; text-align:center; }
        h2 { margin-bottom:30px; }
        table { width:100%; font-size:18px; }
        td { padding:12px; text-align:left; }
        input[type=text], input[type=email], input[type=password] { width:95%; padding:8px; margin:5px 0; border:none; border-radius:5px; }
        button { padding:10px 20px; background:#ffeb3b; border:none; cursor:pointer; font-weight:bold; margin-top:20px; }
        button:hover { background:#ffc107; }
        .msg { margin:10px 0; font-weight:bold; color:yellow; }
        a { display:inline-block; margin-top:20px; padding:10px 20px; background:#ffeb3b; color:#000; text-decoration:none; border-radius:5px; }
        a:hover { background:#ffc107; }
    </style>
</head>
<body>
    <div class="container">
        <h2>My Profile</h2>
        <% if(!message.isEmpty()) { %>
            <div class="msg"><%= message %></div>
        <% } %>
        <form method="post">
            <table>
                <tr><td><b>Username:</b></td><td><input type="text" name="username" value="<%= username %>" readonly></td></tr>
                <tr><td><b>First Name:</b></td><td><input type="text" name="first_name" value="<%= firstName %>" required></td></tr>
                <tr><td><b>Last Name:</b></td><td><input type="text" name="last_name" value="<%= lastName %>" required></td></tr>
                <tr><td><b>Email:</b></td><td><input type="email" name="email" value="<%= email %>" required></td></tr>
                <tr><td><b>New Password:</b></td><td><input type="password" name="new_password"></td></tr>
                <tr><td><b>Confirm Password:</b></td><td><input type="password" name="confirm_password"></td></tr>
            </table>
            <button type="submit">Update Profile</button>
        </form>
        <a href="home.jsp">Back to Home</a>
    </div>
</body>
</html>
