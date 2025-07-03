<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.LocalDate, java.time.temporal.ChronoUnit" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Dashboard - Alex's Trip Agency</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- User Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-plane"></i> Alex's Trip Agency
            </a>
            
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/trips">Browse Trips</a>
                <div class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user"></i> ${sessionScope.user.username}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/dashboard">
                            <i class="fas fa-tachometer-alt"></i> My Dashboard</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>
    
    <div class="container py-4">
        <!-- Success/Error Messages -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle"></i> ${param.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-triangle"></i> ${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <!-- Welcome Section -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card bg-primary text-white">
                    <div class="card-body">
                        <h2 class="mb-1">
                            <i class="fas fa-user-circle"></i> 
                            Welcome, ${sessionScope.user.username}!
                        </h2>
                        <p class="mb-0">Manage your trip bookings and explore new adventures.</p>
                        <a href="${pageContext.request.contextPath}/trips" class="btn btn-warning mt-3">
                            <i class="fas fa-search"></i> Browse Trips
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Quick Stats -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <i class="fas fa-calendar-check fa-3x text-primary mb-3"></i>
                        <h4>
                            <c:choose>
                                <c:when test="${not empty bookings}">
                                    ${bookings.size()}
                                </c:when>
                                <c:otherwise>
                                    0
                                </c:otherwise>
                            </c:choose>
                        </h4>
                        <p class="text-muted">Total Bookings</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <i class="fas fa-clock fa-3x text-warning mb-3"></i>
                        <h4>
                            <c:set var="pendingCount" value="0"/>
                            <c:if test="${not empty bookings}">
                                <c:forEach var="booking" items="${bookings}">
                                    <c:if test="${booking.status == 'PENDING'}">
                                        <c:set var="pendingCount" value="${pendingCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                            ${pendingCount}
                        </h4>
                        <p class="text-muted">Pending Bookings</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                        <h4>
                            <c:set var="confirmedCount" value="0"/>
                            <c:if test="${not empty bookings}">
                                <c:forEach var="booking" items="${bookings}">
                                    <c:if test="${booking.status == 'CONFIRMED'}">
                                        <c:set var="confirmedCount" value="${confirmedCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                            ${confirmedCount}
                        </h4>
                        <p class="text-muted">Confirmed Bookings</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- My Bookings -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-suitcase"></i> My Trip Bookings</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty bookings}">
                                <div class="text-center py-5">
                                    <i class="fas fa-suitcase fa-4x text-muted mb-4"></i>
                                    <h4>No Bookings Yet</h4>
                                    <p class="text-muted mb-4">You haven't made any trip bookings yet. Start exploring our amazing destinations!</p>
                                    <a href="${pageContext.request.contextPath}/trips" class="btn btn-primary btn-lg">
                                        <i class="fas fa-search"></i> Browse Trips
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>Booking #</th>
                                                <th>Trip</th>
                                                <th>Travel Date</th>
                                                <th>Participants</th>
                                                <th>Amount</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="booking" items="${bookings}">
                                                <tr>
                                                    <td><strong>#${booking.bookingId}</strong></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty booking.tripTitle}">
                                                                ${booking.tripTitle}
                                                            </c:when>
                                                            <c:otherwise>
                                                                Trip #${booking.tripId}
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <c:if test="${not empty booking.tripDestination}">
                                                            <br><small class="text-muted">
                                                                <i class="fas fa-map-marker-alt"></i> ${booking.tripDestination}
                                                            </small>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        ${booking.bookingDate}
                                                        <c:if test="${booking.bookingDate != null}">
                                                            <jsp:useBean id="today" class="java.util.Date" />
                                                            <fmt:formatDate var="todayStr" value="${today}" pattern="yyyy-MM-dd" />
                                                            <c:set var="travelDateStr" value="${booking.bookingDate}" />
                                                            <br><small class="text-muted">
                                                                <c:choose>
                                                                    <c:when test="${travelDateStr < todayStr}">
                                                                        <span class="text-secondary">Past travel</span>
                                                                    </c:when>
                                                                    <c:when test="${travelDateStr == todayStr}">
                                                                        <span class="text-info">Today!</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-success">Upcoming</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </small>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <i class="fas fa-users"></i> ${booking.participants}
                                                    </td>
                                                    <td>
                                                        <strong>£<fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0.00"/></strong>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${booking.status == 'CONFIRMED'}">
                                                                <span class="badge bg-success">Confirmed</span>
                                                            </c:when>
                                                            <c:when test="${booking.status == 'PENDING'}">
                                                                <span class="badge bg-warning">Pending</span>
                                                            </c:when>
                                                            <c:when test="${booking.status == 'CANCELLED'}">
                                                                <span class="badge bg-danger">Cancelled</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${booking.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm">
                                                            <a href="${pageContext.request.contextPath}/trip-details?id=${booking.tripId}" 
                                                               class="btn btn-outline-primary" title="View Trip">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/booking-confirmation?bookingId=${booking.bookingId}" 
                                                               class="btn btn-outline-info" title="View Booking">
                                                                <i class="fas fa-receipt"></i>
                                                            </a>
                                                            
                                                            <!-- Cancel Button - Only show for eligible bookings -->
                                                            <c:if test="${booking.status != 'CANCELLED'}">
                                                                <jsp:useBean id="currentDate" class="java.util.Date" />
                                                                <fmt:formatDate var="currentDateStr" value="${currentDate}" pattern="yyyy-MM-dd" />
                                                                <c:set var="bookingDateStr" value="${booking.bookingDate}" />
                                                                
                                                                <!-- Check if booking can be cancelled (at least 2 days notice) -->
                                                                <c:if test="${bookingDateStr > currentDateStr}">
                                                                    <button type="button" class="btn btn-outline-danger" 
                                                                            onclick="cancelBooking(${booking.bookingId}, '${booking.tripTitle}')" 
                                                                            title="Cancel Booking">
                                                                        <i class="fas fa-times"></i>
                                                                    </button>
                                                                </c:if>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                
                                <!-- Cancellation Policy Notice -->
                                <div class="alert alert-info mt-3">
                                    <h6><i class="fas fa-info-circle"></i> Cancellation Policy</h6>
                                    <ul class="mb-0">
                                        <li>Bookings can be cancelled up to 2 days before the travel date</li>
                                        <li>Confirmed and pending bookings are eligible for cancellation</li>
                                        <li>Available spots will be automatically restored upon cancellation</li>
                                        <li>For cancellations within 48 hours of travel, please contact our support team</li>
                                    </ul>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Cancel Booking Confirmation Modal -->
    <div class="modal fade" id="cancelModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Cancel Booking</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <strong>Are you sure you want to cancel this booking?</strong>
                    </div>
                    <p>Booking for: <strong id="tripTitle"></strong></p>
                    <p>This action cannot be undone, but the available spots will be restored for other travelers.</p>
                    <div class="text-muted">
                        <small>
                            <i class="fas fa-info-circle"></i>
                            If you change your mind, you can book this trip again if spots are available.
                        </small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times"></i> Keep Booking
                    </button>
                    <form id="cancelForm" method="POST" action="${pageContext.request.contextPath}/user/cancel-booking" style="display: inline;">
                        <input type="hidden" id="bookingIdInput" name="bookingId">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-trash"></i> Yes, Cancel Booking
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        function cancelBooking(bookingId, tripTitle) {
            document.getElementById('bookingIdInput').value = bookingId;
            document.getElementById('tripTitle').textContent = tripTitle || 'Trip #' + bookingId;
            new bootstrap.Modal(document.getElementById('cancelModal')).show();
        }
        
        // Auto-dismiss alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert-dismissible');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    const bsAlert = new bootstrap.Alert(alert);
                    if (bsAlert) {
                        bsAlert.close();
                    }
                }, 5000);
            });
        });
    </script>
</body>
</html>