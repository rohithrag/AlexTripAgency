<!-- File: web/trip-details.jsp (SIMPLIFIED) -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="pageTitle" value="${trip.title}" />
<%@ include file="includes/header.jsp" %>

<div class="container py-4">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/trips">Trips</a></li>
            <li class="breadcrumb-item active">${trip.title}</li>
        </ol>
    </nav>
    
    <div class="row">
        <div class="col-lg-8">
            <div class="card">
                <c:choose>
                    <c:when test="${not empty trip.imageUrl}">
                        <img src="${pageContext.request.contextPath}/${trip.imageUrl}" 
                             class="card-img-top" style="height: 300px; object-fit: cover;" alt="${trip.title}">
                    </c:when>
                    <c:otherwise>
                        <div class="bg-light d-flex align-items-center justify-content-center" style="height: 300px;">
                            <i class="fas fa-image fa-5x text-muted"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <div class="card-body">
                    <h1 class="card-title">${trip.title}</h1>
                    <p class="lead text-muted mb-3">
                        <i class="fas fa-map-marker-alt"></i> ${trip.destination}
                    </p>
                    
                    <div class="row mb-4">
                        <div class="col-md-3 col-6 text-center border-end">
                            <i class="fas fa-calendar-alt fa-2x text-primary mb-2"></i>
                            <h6>Duration</h6>
                            <p class="mb-0">${trip.duration} days</p>
                        </div>
                        <div class="col-md-3 col-6 text-center border-end">
                            <i class="fas fa-users fa-2x text-primary mb-2"></i>
                            <h6>Max Group</h6>
                            <p class="mb-0">${trip.maxParticipants} people</p>
                        </div>
                        <div class="col-md-3 col-6 text-center border-end">
                            <i class="fas fa-tag fa-2x text-primary mb-2"></i>
                            <h6>Activity</h6>
                            <p class="mb-0">${trip.activityType}</p>
                        </div>
                        <div class="col-md-3 col-6 text-center">
                            <i class="fas fa-check-circle fa-2x text-success mb-2"></i>
                            <h6>Available</h6>
                            <p class="mb-0">${trip.availableSpots} spots</p>
                        </div>
                    </div>
                    
                    <h3>Trip Description</h3>
                    <p class="lead">${trip.description}</p>
                    
                    <c:if test="${not empty trip.startDate and not empty trip.endDate}">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i>
                            <strong>Trip Dates Available:</strong> ${trip.startDate} to ${trip.endDate}
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        
        <div class="col-lg-4">
            <div class="card border-primary">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-credit-card"></i> Book This Trip</h5>
                </div>
                <div class="card-body">
                    <div class="text-center mb-3">
                        <span class="h2 text-primary">£<fmt:formatNumber value="${trip.price}" pattern="#,##0.00"/></span>
                        <div class="text-muted">per person</div>
                    </div>
                    
                    <c:choose>
                        <c:when test="${trip.availableSpots > 0}">
                            <div class="d-grid">
                                <a href="${pageContext.request.contextPath}/booking?tripId=${trip.tripId}" 
                                   class="btn btn-primary btn-lg">
                                    <i class="fas fa-plane"></i> Book Now
                                </a>
                            </div>
                            
                            <div class="mt-3">
                                <c:choose>
                                    <c:when test="${trip.availableSpots <= 5}">
                                        <div class="alert alert-warning mb-0">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            Only ${trip.availableSpots} spots left!
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-success mb-0">
                                            <i class="fas fa-check-circle"></i>
                                            ${trip.availableSpots} spots available
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-danger">
                                <i class="fas fa-times-circle"></i>
                                This trip is fully booked
                            </div>
                            <div class="d-grid">
                                <button class="btn btn-secondary btn-lg" disabled>
                                    Fully Booked
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Additional trip info -->
            <div class="card mt-3">
                <div class="card-header">
                    <h6 class="mb-0"><i class="fas fa-info-circle"></i> What's Included</h6>
                </div>
                <div class="card-body">
                    <ul class="list-unstyled mb-0">
                        <li class="mb-2">
                            <i class="fas fa-shield-alt text-success"></i>
                            Travel insurance included
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-user-tie text-primary"></i>
                            Professional guide
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-headset text-info"></i>
                            24/7 support
                        </li>
                        <li>
                            <i class="fas fa-undo text-warning"></i>
                            Flexible cancellation
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>