<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String user = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home - E-Vehicle Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        html { scroll-behavior: smooth; }
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(270deg, #89f7fe, #66a6ff, #6a11cb, #2575fc);
            background-size: 600% 600%;
            color: #fff;
            animation: backgroundMove 15s ease infinite;
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
        nav ul {
            list-style: none; display: flex; flex-wrap: nowrap; margin: 0; padding: 0; align-items: center;
        }
        nav ul li { margin-left: 30px; white-space: nowrap; }
        nav ul li a {
            display: flex; align-items: center; gap: 6px; color: #fff; text-decoration: none; font-weight: bold;
            padding: 8px 15px; border-radius: 25px; transition: all 0.3s ease;
        }
        nav ul li a:hover { color: #ffe600; background: rgba(255,255,255,0.15); transform: scale(1.1) translateY(-2px); box-shadow: 0 0 10px #ffe600; }
        .content { text-align: center; padding: 100px 20px 40px; animation: fadeInUp 1s ease-in-out; }
        .content h2 { font-size: 40px; margin-bottom: 20px; animation: floatingText 2s ease-in-out infinite alternate; }
        .content p { font-size: 18px; max-width: 600px; margin: auto; animation: fadeIn 1.5s ease; }
        .offer-section { max-width: 900px; margin: 40px auto; padding: 30px; background: rgba(255,255,255,0.1); border-radius: 12px; text-align: center; box-shadow: 0 8px 25px rgba(0,0,0,0.4); backdrop-filter: blur(6px); animation: fadeInUp 1s ease-in-out; }
        .offer-section h3 { font-size: 28px; margin-bottom: 10px; color: #ffe600; animation: glow 1.5s infinite alternate; }
        .offer-section p { font-size: 18px; margin: 10px 0 20px; }
        .offer-card { display: inline-block; background: rgba(0,0,0,0.5); padding: 20px 30px; border-radius: 10px; margin-top: 15px; transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .offer-card:hover { transform: scale(1.05); box-shadow: 0 0 20px #ffe600; }
        .offer-btn { background: #ffe600; color: #000; padding: 10px 20px; border: none; border-radius: 5px; font-size: 16px; font-weight: bold; cursor: pointer; transition: background 0.3s ease; }
        .offer-btn:hover { background: #ffcc00; }
        .feedback-section { max-width: 1000px; margin: 50px auto; padding: 40px; background: rgba(255,255,255,0.1); border-radius: 12px; box-shadow: 0 8px 25px rgba(0,0,0,0.4); backdrop-filter: blur(6px); text-align: center; }
        .feedback-section h3 { font-size: 28px; margin-bottom: 30px; color: #ffe600; }
        .feedback-container { display: flex; flex-wrap: wrap; justify-content: center; gap: 30px; }
        .feedback-card { background: rgba(0,0,0,0.6); width: 280px; padding: 20px; border-radius: 12px; transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .feedback-card:hover { transform: scale(1.05); box-shadow: 0 0 20px #ffe600; }
        .feedback-card img { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; margin-bottom: 15px; }
        .feedback-card h4 { font-size: 20px; margin: 10px 0 5px; color: #fff; }
        .feedback-card p { font-size: 16px; font-style: italic; color: #ddd; }
        .stars i { color: #ffe600; margin: 2px; }
        .info-section { max-width: 900px; margin: 50px auto; background: rgba(255,255,255,0.1); padding: 40px; border-radius: 12px; box-shadow: 0 8px 25px rgba(0,0,0,0.4); backdrop-filter: blur(6px); opacity: 0; transform: translateY(30px) scale(0.95); transition: all 0.5s ease; }
        .info-section.show { opacity: 1; transform: translateY(0) scale(1); }
        .info-section h3 { font-size: 28px; margin-bottom: 15px; text-align: center; color: #ffe600; }
        .info-section p { font-size: 17px; line-height: 1.7; text-align: center; }
        footer { background: rgba(0,0,0,0.7); padding: 20px; text-align: center; font-size: 14px; margin-top: 50px; animation: fadeIn 2s ease; }
        #backToTop { position: fixed; bottom: 30px; right: 30px; background: #ffe600; color: #000; padding: 12px 16px; border-radius: 50%; font-size: 20px; cursor: pointer; box-shadow: 0 5px 15px rgba(0,0,0,0.3); opacity: 0; visibility: hidden; transition: opacity 0.3s ease, transform 0.3s ease; z-index: 1000; }
        #backToTop.show { opacity: 1; visibility: visible; transform: scale(1.1); }
        @keyframes backgroundMove { 0% {background-position: 0% 50%;} 50% {background-position: 100% 50%;} 100% {background-position: 0% 50%;} }
        @keyframes fadeInUp { from {opacity: 0; transform: translateY(40px);} to {opacity: 1; transform: translateY(0);} }
        @keyframes fadeIn { from {opacity: 0;} to {opacity: 1;} }
        @keyframes floatingText { from {transform: translateY(0);} to {transform: translateY(-8px);} }
        @keyframes textGlow { from {text-shadow: 0 0 10px #00ffff;} to {text-shadow: 0 0 20px #00ffff, 0 0 40px #00ffff;} }
        @keyframes glow { from {text-shadow: 0 0 5px #ffe600, 0 0 10px #ffcc00;} to {text-shadow: 0 0 15px #ffe600, 0 0 30px #ffcc00;} }
    </style>
</head>
<body>
  <header id="mainHeader">
    <h1><i class="fa-solid fa-bolt"></i> E-Vehicle Portal</h1>
    <nav>
        <ul>
            <li><a href="nearbyStations.jsp"><i class="fa-solid fa-location-dot"></i> Nearby Charging Station</a></li>
            <% if (user != null) { %>
                <li><a href="profile.jsp"><i class="fa-solid fa-user"></i> My Profile</a></li>
                <li><a href="orders.jsp"><i class="fa-solid fa-list"></i> My Orders</a></li>
                <li><a href="stations.jsp"><i class="fa-solid fa-charging-station"></i> Stations</a></li>
                <li><a href="logout.jsp"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
            <% } else { %>
                <li><a href="stations.jsp"><i class="fa-solid fa-charging-station"></i> Stations</a></li>
                <li><a href="login.jsp?action=guest"><i class="fa-solid fa-right-to-bracket"></i> Login</a></li>
                <li><a href="adminLogin.jsp"><i class="fa-solid fa-user-shield"></i> Admin Login</a></li>
                <li><a href="contact.jsp"><i class="fa-solid fa-envelope"></i> Contact</a></li>
            <% } %>
        </ul>
    </nav>
</header>



    <div class="content">
        <h2>
            Welcome, <%= (user != null) ? user : "Guest" %>!
        </h2>
        <p>"Drive the future today – go electric, go green, go beyond!"</p>
    </div>

    <!-- Offers Section -->
    <div class="offer-section">
        <h3><i class="fa-solid fa-gift"></i> Special DIWALI Offer!</h3>
        <p>Recharge your EV unlimited times this festive season with our <b>Monthly Unlimited Charging Pack</b> at just <b>₹999</b>.</p>
        <div class="offer-card">
            <p><b>Benefits:</b> Unlimited Charging • Priority Slot Booking • 24/7 Support</p>
            <a href="plan.jsp" class="offer-btn">Grab Now</a>
        </div>
    </div>

    <!-- Customer Feedback Section -->
    <div class="feedback-section">
        <h3><i class="fa-solid fa-comments"></i> What Our Customers Say</h3>
        <div class="feedback-container">
            <div class="feedback-card">
                <img src="images/user1.jpg" alt="Customer 1">
                <h4>Rahul Sharma</h4>
                <p>"Amazing experience! Easy booking and fast charging stations everywhere."</p>
                <div class="stars">
                    <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star-half-stroke"></i>
                </div>
            </div>
            <div class="feedback-card">
                <img src="images/user2.jpg" alt="Customer 2">
                <h4>Priya Verma</h4>
                <p>"Best EV service ever, affordable and reliable. Highly recommend!"</p>
                <div class="stars">
                    <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                </div>
            </div>
            <div class="feedback-card">
                <img src="images/user3.jpg" alt="Customer 3">
                <h4>Arjun Kumar</h4>
                <p>"Great customer support and convenient locations for charging."</p>
                <div class="stars">
                    <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-regular fa-star"></i>
                </div>
            </div>
        </div>
    </div>

    <div id="about" class="info-section">
        <h3><i class="fa-solid fa-circle-info"></i> About Us</h3>
        <p>E-Vehicle Portal is your one-stop platform for booking EV charging stations. 
           We aim to accelerate the shift to sustainable mobility and support a greener future.</p>
    </div>

    <div id="contact" class="info-section">
        <h3><i class="fa-solid fa-envelope"></i> Contact Us</h3>
        <p><i class="fa-solid fa-envelope"></i> <b>Email:</b> support@evehicleportal.com<br>
           <i class="fa-solid fa-phone"></i> <b>Phone:</b> +91-9677676898<br>
           <i class="fa-solid fa-location-dot"></i> <b>Address:</b> 123, Green Energy Street, Clean City, India</p>
    </div>

    <footer>
        &copy; 2025 E-Vehicle Portal. All Rights Reserved.
    </footer>

    <div id="backToTop"><i class="fa-solid fa-arrow-up"></i></div>

    <script>
        const observer = new IntersectionObserver(entries => {
            entries.forEach(entry => { if(entry.isIntersecting) entry.target.classList.add('show'); });
        }, {threshold: 0.2});
        document.querySelectorAll('.info-section').forEach(section => observer.observe(section));

        const header = document.getElementById('mainHeader');
        window.addEventListener('scroll', () => { if(window.scrollY > 50) header.classList.add('transparent'); else header.classList.remove('transparent'); });

        const backToTop = document.getElementById('backToTop');
        window.addEventListener('scroll', () => { if(window.scrollY > 300) backToTop.classList.add('show'); else backToTop.classList.remove('show'); });
        backToTop.addEventListener('click', () => window.scrollTo({top: 0, behavior: 'smooth'}));
    </script>
</body>
</html>
