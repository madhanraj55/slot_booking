<%
    // Clear session
    session.invalidate();

    // Prevent browser cache (back button issue)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Redirect to guest home page
    response.sendRedirect("home.jsp");
%>
