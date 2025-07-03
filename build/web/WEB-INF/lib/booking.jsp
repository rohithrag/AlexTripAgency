<!-- File: web/booking.jsp (SIMPLIFIED) -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="pageTitle" value="Book Trip - ${trip.title}" />
<%@ include file="includes/header.jsp" %>

<div class="container py-4">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/trips">Trips</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/trip-details?id=${trip.tripId}">${trip.title}</a></li>
            <li class="breadcrumb-item active">Booking</li>
        </ol>
    </nav>
    
    <div class="row">
        <div class="col-lg-8">
            <div class="card">
                <div class="card-header">
                    <h4 class="mb-0"><i class="fas fa-credit-card"></i> Book Your Trip</h4>
                </div>
                <div class="card-body">
                    <!-- Display errors if any -->
                    <c:if test="${not empty errors}">
                        <div class="alert alert-danger">
                            <h6>Please correct the following errors:</h6>
                            <ul class="mb-0">
                                <c:forEach var="error" items="${errors}">
                                    <li>${error}</li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    
                    <form method="POST" action="${pageContext.request.contextPath}/booking" id="bookingForm">
                        <input type="hidden" name="tripId" value="${trip.tripId}">
                        
                        <!-- Customer Information -->
                        <div class="row mb-4">
                            <div class="col-12">
                                <h5><i class="fas fa-user"></i> Customer Information</h5>
                                <hr>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="customerName" class="form-label">Full Name *</label>
                                <input type="text" class="form-control" id="customerName" name="customerName" 
                                       value="${param.customerName}" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="customerEmail" class="form-label">Email Address *</label>
                                <input type="email" class="form-control" id="customerEmail" name="customerEmail" 
                                       value="${param.customerEmail}" required>
                            </div>
                            
                            <div class="col-md-6 mt-3">
                                <label for="customerPhone" class="form-label">Phone Number</label>
                                <input type="tel" class="form-control" id="customerPhone" name="customerPhone" 
                                       value="${param.customerPhone}">
                            </div>
                            
                            <div class="col-md-6 mt-3">
                                <label for="participants" class="form-label">Number of Participants *</label>
                                <select class="form-select" id="participants" name="participants" required onchange="updateTotal()">
                                    <option value="">Select participants</option>
                                    <c:forEach var="i" begin="1" end="${trip.availableSpots}">
                                        <option value="${i}" ${param.participants == i ? 'selected' : ''}>${i}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <div class="col-md-6 mt-3">
                                <label for="bookingDate" class="form-label">Preferred Travel Date *</label>
                                <input type="date" class="form-control" id="bookingDate" name="bookingDate" 
                                       value="${param.bookingDate}" required>
                            </div>
                        </div>
                        
                        <!-- Total Cost Display -->
                        <div class="row mb-4">
                            <div class="col-12">
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <h6>Price per person: £<fmt:formatNumber value="${trip.price}" pattern="#,##0.00"/></h6>
                                            </div>
                                            <div class="col-md-6 text-end">
                                                <h5 id="totalCost">Total: £0.00</h5>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/trip-details?id=${trip.tripId}" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Back to Trip
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-credit-card"></i> Confirm Booking
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-lg-4">
            <!-- Trip Summary -->
            <div class="card">
                <div class="card-header">
                    <h6 class="mb-0"><i class="fas fa-map-marked-alt"></i> Trip Summary</h6>
                </div>
                <div class="card-body">
                    <h6 class="card-title">${trip.title}</h6>
                    <p class="card-text">
                        <i class="fas fa-map-marker-alt"></i> ${trip.destination}<br>
                        <i class="fas fa-calendar-alt"></i> ${trip.duration} days<br>
                        <i class="fas fa-tag"></i> ${trip.activityType}
                    </p>
                    
                    <c:if test="${not empty trip.startDate and not empty trip.endDate}">
                        <div class="alert alert-info">
                            <small>
                                <strong>Available dates:</strong><br>
                                ${trip.startDate} to ${trip.endDate}
                            </small>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Price per person from server
const pricePerPerson = ${trip.price};

function updateTotal() {
    const participants = document.getElementById('participants').value;
    const totalCost = participants ? (pricePerPerson * participants) : 0;
    document.getElementById('totalCost').textContent = 
        'Total: £' + totalCost.toLocaleString('en-GB', {minimumFractionDigits: 2, maximumFractionDigits: 2});
}

// Initialize
window.onload = function() {
    updateTotal();
};
</script>

<%@ include file="includes/footer.jsp" %>