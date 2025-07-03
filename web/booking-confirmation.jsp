<!-- File: web/booking-confirmation.jsp (SIMPLIFIED) -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="pageTitle" value="Booking Confirmation" />
<%@ include file="includes/header.jsp" %>

<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card">
                <div class="card-header bg-success text-white text-center">
                    <h4 class="mb-0">
                        <i class="fas fa-check-circle"></i> Booking Confirmed!
                    </h4>
                </div>
                <div class="card-body">
                    <div class="text-center mb-4">
                        <div class="alert alert-success">
                            <h5>Thank you for your booking!</h5>
                            <p class="mb-0">Your trip has been successfully booked. You will receive a confirmation email shortly.</p>
                        </div>
                    </div>
                    
                    <!-- Booking Details -->
                    <div class="row">
                        <div class="col-md-6">
                            <h6><i class="fas fa-ticket-alt"></i> Booking Details</h6>
                            <table class="table table-sm">
                                <tr>
                                    <td><strong>Booking ID:</strong></td>
                                    <td>#${booking.bookingId}</td>
                                </tr>
                                <tr>
                                    <td><strong>Customer:</strong></td>
                                    <td>${booking.customerName}</td>
                                </tr>
                                <tr>
                                    <td><strong>Email:</strong></td>
                                    <td>${booking.customerEmail}</td>
                                </tr>
                                <tr>
                                    <td><strong>Phone:</strong></td>
                                    <td>${booking.customerPhone}</td>
                                </tr>
                                <tr>
                                    <td><strong>Participants:</strong></td>
                                    <td>${booking.participants}</td>
                                </tr>
                                <tr>
                                    <td><strong>Total Amount:</strong></td>
                                    <td><strong>£<fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0.00"/></strong></td>
                                </tr>
                                <tr>
                                    <td><strong>Status:</strong></td>
                                    <td><span class="badge bg-warning">${booking.status}</span></td>
                                </tr>
                            </table>
                        </div>
                        
                        <div class="col-md-6">
                            <h6><i class="fas fa-map-marked-alt"></i> Trip Information</h6>
                            <table class="table table-sm">
                                <tr>
                                    <td><strong>Trip:</strong></td>
                                    <td>${trip.title}</td>
                                </tr>
                                <tr>
                                    <td><strong>Destination:</strong></td>
                                    <td>${trip.destination}</td>
                                </tr>
                                <tr>
                                    <td><strong>Duration:</strong></td>
                                    <td>${trip.duration} days</td>
                                </tr>
                                <tr>
                                    <td><strong>Activity:</strong></td>
                                    <td>${trip.activityType}</td>
                                </tr>
                                <tr>
                                    <td><strong>Travel Date:</strong></td>
                                    <td>${booking.bookingDate}</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    
                    <hr>
                    
                    <div class="row">
                        <div class="col-12">
                            <h6><i class="fas fa-info-circle"></i> What's Next?</h6>
                            <ul class="list-unstyled">
                                <li class="mb-2">
                                    <i class="fas fa-envelope text-primary"></i>
                                    You will receive a confirmation email with your booking details
                                </li>
                                <li class="mb-2">
                                    <i class="fas fa-phone text-success"></i>
                                    Our team will contact you within 24 hours to finalize the details
                                </li>
                                <li class="mb-2">
                                    <i class="fas fa-file-alt text-info"></i>
                                    Travel documents and itinerary will be sent 1 week before departure
                                </li>
                                <li>
                                    <i class="fas fa-headset text-warning"></i>
                                    For any questions, contact our support team at +1 (555) 123-4567
                                </li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="text-center mt-4">
                        <a href="${pageContext.request.contextPath}/trips" class="btn btn-primary me-2">
                            <i class="fas fa-search"></i> Browse More Trips
                        </a>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                            <i class="fas fa-home"></i> Back to Home
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>