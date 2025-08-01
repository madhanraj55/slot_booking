<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String user = (String) session.getAttribute("username");

    // Database credentials
    String url = "jdbc:mysql://localhost:3306/ev_portal";
    String dbUser = "root";   // change if needed
    String dbPass = "root";   // change if needed
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Select District</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        html { scroll-behavior: smooth; }
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(270deg, #89f7fe, #66a6ff, #6a11cb, #2575fc);
            background-size: 600% 600%;
            animation: backgroundMove 15s ease infinite;
            color: #fff;
        }
        header {
            background: rgba(0,0,0,0.7);
            padding: 20px 40px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.4);
            position: sticky; top: 0; z-index: 999;
            transition: background 0.4s ease, padding 0.4s ease;
        }
        header.transparent { background: rgba(0,0,0,0.4); padding: 10px 40px; }
        header h1 { margin: 0; font-size: 28px; animation: textGlow 2s infinite alternate; }
        main { text-align: center; padding: 120px 20px 40px; }
        h2 { font-size: 32px; margin-bottom: 40px; animation: floatingText 2s ease-in-out infinite alternate; }
        .district-card {
            display: inline-block;
            background: rgba(255,255,255,0.15);
            color: #ffe600;
            padding: 20px 40px;
            margin: 20px;
            font-size: 20px;
            font-weight: 500;
            border-radius: 12px;
            text-decoration: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            opacity: 0; transform: translateY(30px) scale(0.95);
            transition: all 0.4s ease;
        }
        .district-card.show { opacity: 1; transform: translateY(0) scale(1); }
        .district-card:hover {
            transform: translateY(-8px) scale(1.08);
            box-shadow: 0 0 15px #ffe600, 0 0 30px #ffe600;
        }
        footer {
            background: rgba(0,0,0,0.7); padding: 20px; text-align: center;
            font-size: 14px; margin-top: 50px;
        }
        #backToTop {
            position: fixed; bottom: 30px; right: 30px;
            background: #ffe600; color: #000;
            padding: 12px 16px; border-radius: 50%;
            font-size: 20px; cursor: pointer;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            opacity: 0; visibility: hidden;
            transition: opacity 0.3s ease, transform 0.3s ease;
            z-index: 1000;
        }
        #backToTop.show { opacity: 1; visibility: visible; transform: scale(1.1); }

        /* Animations */
        @keyframes backgroundMove { 0% {background-position: 0% 50%;} 50% {background-position: 100% 50%;} 100% {background-position: 0% 50%;} }
        @keyframes floatingText { from {transform: translateY(0);} to {transform: translateY(-8px);} }
        @keyframes textGlow { from {text-shadow: 0 0 10px #00ffff;} to {text-shadow: 0 0 20px #00ffff, 0 0 40px #00ffff;} }
    </style>
</head>
<body>
    <header id="mainHeader">
        <h1><i class="fa-solid fa-bolt"></i> EV Portal</h1>
    </header>

    <main>
        <h2>Select Your District</h2>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(url, dbUser, dbPass);
                PreparedStatement ps = con.prepareStatement("SELECT DISTINCT district FROM ev_stations ORDER BY district");
                ResultSet rs = ps.executeQuery();
                boolean found = false;
                while(rs.next()) {
                    found = true;
        %>
            <a class="district-card" href="stationDetails.jsp?name=<%= rs.getString("district") %>">
                <%= rs.getString("district") %>
            </a>
        <%
                }
                if(!found) {
                    out.println("<p style='color:red;'>No districts found!</p>");
                }
                con.close();
            } catch(Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        %>

        <%-- Optional message for booking feature --%>
        <% if(user == null){ %>
            <p style="margin-top:40px; color:#fff;">
                <i class="fa-solid fa-lock"></i> 
                <b>Note:</b> Login is required for booking stations.
                <a href="login.jsp" style="color:#ffe600; text-decoration: underline;">Login here</a>
            </p>
        <% } %>
    </main>

    <footer>
        &copy; 2025 E-Vehicle Portal. All Rights Reserved.
    </footer>

    <!-- Back to Top Button -->
    <div id="backToTop"><i class="fa-solid fa-arrow-up"></i></div>

    <script>
        const observer = new IntersectionObserver(entries => {
            entries.forEach(entry => {
                if(entry.isIntersecting) entry.target.classList.add('show');
            });
        }, {threshold: 0.2});
        document.querySelectorAll('.district-card').forEach(card => observer.observe(card));

        const header = document.getElementById('mainHeader');
        window.addEventListener('scroll', () => {
            if(window.scrollY > 50) header.classList.add('transparent');
            else header.classList.remove('transparent');
        });

        const backToTop = document.getElementById('backToTop');
        window.addEventListener('scroll', () => {
            if(window.scrollY > 300) backToTop.classList.add('show');
            else backToTop.classList.remove('show');
        });
        backToTop.addEventListener('click', () => window.scrollTo({top: 0, behavior: 'smooth'}));
    </script>
</body>
</html>
