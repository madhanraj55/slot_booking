<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Employee List</title>
</head>
<body>
    <h2>Registered Employees</h2>
    <a href="employee?action=NEW">Add New Employee</a><br><br>
<table style="border-collapse: collapse; border: 1px solid black;">

        <tr>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Username</th>
            <th>Password</th>
            <th>Email</th>
        </tr>
        <c:forEach var="emp" items="${listEmployee}">
            <tr>
                <td>${emp.firstName}</td>
                <td>${emp.lastName}</td>
                <td>${emp.username}</td>
                <td>${emp.password}</td>
                <td>${emp.email}</td>
            </tr>
        </c:forEach>
    </table>
    <br>
    <a href="employee?action=NEW">Register Another Employee</a>
</body>
</html>
