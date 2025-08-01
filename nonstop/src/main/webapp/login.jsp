<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String message = "";
    String action = request.getParameter("action");  // "guest" or "booking"

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ev_portal", "root", "root");

            // Validate username & password from users table
            String sql = "SELECT * FROM users WHERE username=? AND password=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("username", username);

                // Redirect based on source action
                if ("booking".equalsIgnoreCase(action)) {
                    response.sendRedirect("scanPage.jsp");   // Booking flow
                } else {
                    response.sendRedirect("home.jsp");        // Guest flow → back to home
                }
                return; // stop further execution
            } else {
                message = "Invalid username or password!";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (ps != null) try { ps.close(); } catch (Exception ignored) {}
            if (con != null) try { con.close(); } catch (Exception ignored) {}
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - E-Vehicle Portal</title>
    <style>
        body { display:flex; justify-content:center; align-items:center; height:100vh;
               background:linear-gradient(120deg,#89f7fe,#66a6ff); font-family:sans-serif; }
        .login-box { background:rgba(255,255,255,0.1); padding:40px; border-radius:15px;
                     box-shadow:0 4px 20px rgba(0,0,0,0.3); text-align:center; width:300px; }
        .login-box h2 { margin-bottom:20px; color:#fff; text-shadow:0 0 10px #000; }
        input[type=text], input[type=password] { width:100%; padding:10px; margin:10px 0;
                                                 border:none; border-radius:8px; }
        button { padding:10px 30px; background:#ffeb3b; border:none; font-size:16px;
                 font-weight:bold; cursor:pointer; border-radius:8px; transition:0.3s; width:100%; }
        button:hover { background:#ffc107; transform:scale(1.05); }
        .register-link { margin-top:15px; font-size:14px; color:#fff; }
        .register-link a { color:#ffeb3b; text-decoration:none; font-weight:bold; }
        .register-link a:hover { text-decoration:underline; }
        .error-msg { color:red; font-weight:bold; margin-bottom:10px; }
    </style>
</head>
<body>
<div class="login-box">
    <h2>Customer Login</h2>
    <% if(!message.isEmpty()) { %>
        <p class="error-msg"><%= message %></p>
    <% } %>
    <!-- Keep action parameter while submitting -->
    <form action="login.jsp?action=<%= (action != null) ? action : "guest" %>" method="post">
        <input type="text" name="username" placeholder="Username" required><br>
        <input type="password" name="password" placeholder="Password" required><br>
        <button type="submit">Login</button>
    </form>
    <div class="register-link">
        New user? <a href="employee-form.jsp">Register here</a>
    </div>
</div>
</body>
</html>
