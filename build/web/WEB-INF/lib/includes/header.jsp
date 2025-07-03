<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Alex's Trip Agency</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-plane"></i> Alex's Trip Agency
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
                    data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/trips">Browse Trips</a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <!-- User is logged in -->
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" 
                                   data-bs-toggle="dropdown">
                                    <i class="fas fa-user"></i> 
                                    ${sessionScope.user.fullName != null ? sessionScope.user.fullName : sessionScope.user.username}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <c:choose>
                                        <c:when test="${sessionScope.user.role == 'ADMIN'}">
                                            <!-- Admin Menu -->
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">
                                                <i class="fas fa-tachometer-alt"></i> Admin Dashboard</a></li>
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/trips">
                                                <i class="fas fa-map-marked-alt"></i> Manage Trips</a></li>
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/bookings">
                                                <i class="fas fa-calendar-check"></i> View All Bookings</a></li>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Regular User Menu -->
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/dashboard">
                                                <i class="fas fa-tachometer-alt"></i> My Dashboard</a></li>
                                        </c:otherwise>
                                    </c:choose>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                        <i class="fas fa-sign-out-alt"></i> Logout</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <!-- User not logged in -->
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                    <i class="fas fa-sign-in-alt"></i> Login
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/register">
                                    <i class="fas fa-user-plus"></i> Register
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>