<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="pageTitle" value="Browse Trips" />
<%@ include file="includes/header.jsp" %>

<div class="container py-4">
    <h1 class="mb-4">Browse Our Trips</h1>
    
    <!-- Search Form -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="GET" action="${pageContext.request.contextPath}/trips">
                <div class="row">
                    <div class="col-md-3">
                        <select class="form-select" name="destination">
                            <option value="">All Destinations</option>
                            <c:forEach var="dest" items="${destinations}">
                                <option value="${dest}">${dest}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" name="activityType">
                            <option value="">All Activities</option>
                            <c:forEach var="activity" items="${activityTypes}">
                                <option value="${activity}">${activity}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <input type="number" class="form-control" name="maxPrice" placeholder="Max Price">
                    </div>
                    <div class="col-md-2">
                        <input type="number" class="form-control" name="maxDuration" placeholder="Max Days">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">Search</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Trip Results -->
    <div class="row">
        <c:choose>
            <c:when test="${empty trips}">
                <div class="col-12">
                    <div class="alert alert-info text-center">
                        No trips found. <a href="${pageContext.request.contextPath}/trips">View all trips</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="trip" items="${trips}">
                    <div class="col-md-4 mb-4">
                        <div class="card h-100">
                            <div class="card-body">
                                <h5 class="card-title">${trip.title}</h5>
                                <p class="card-text">${trip.destination}</p>
                                <p class="card-text">${trip.description}</p>
                                <div class="row text-center mb-3">
                                    <div class="col-4">
                                        <small>Duration</small><br>
                                        <strong>${trip.duration} days</strong>
                                    </div>
                                    <div class="col-4">
                                        <small>Activity</small><br>
                                        <strong>${trip.activityType}</strong>
                                    </div>
                                    <div class="col-4">
                                        <small>Available</small><br>
                                        <strong>${trip.availableSpots}</strong>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="h5 text-primary">£<fmt:formatNumber value="${trip.price}" pattern="#,##0.00"/></span>
                                    <a href="${pageContext.request.contextPath}/trip-details?id=${trip.tripId}" class="btn btn-primary">
                                        View Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>