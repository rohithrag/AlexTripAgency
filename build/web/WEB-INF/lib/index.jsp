<!-- File: web/index.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="pageTitle" value="Home" />
<%@ include file="includes/header.jsp" %>

<div class="hero-section">
    <div class="container">
        <div class="row align-items-center min-vh-75">
            <div class="col-lg-6">
                <h1 class="display-4 fw-bold text-white mb-4">
                    Discover Amazing Adventures
                </h1>
                <p class="lead text-white mb-4">
                    Explore the world with Alex's Trip Agency. From exotic destinations to thrilling adventures, 
                    we make your travel dreams come true.
                </p>
                <a href="${pageContext.request.contextPath}/trips" class="btn btn-warning btn-lg">
                    <i class="fas fa-search"></i> Browse Trips
                </a>
            </div>
            <div class="col-lg-6">
                <img src="images/hero-travel.jpg" alt="Travel Adventure" class="img-fluid rounded shadow">
            </div>
        </div>
    </div>
</div>

<div class="container py-5">
    <div class="row text-center mb-5">
        <div class="col-12">
            <h2 class="display-5 fw-bold">Why Choose Us?</h2>
            <p class="lead">We provide exceptional travel experiences with professional service</p>
        </div>
    </div>
    
    <div class="row g-4">
        <div class="col-md-4">
            <div class="feature-card text-center">
                <div class="feature-icon">
                    <i class="fas fa-globe-americas"></i>
                </div>
                <h4>Global Destinations</h4>
                <p>Explore amazing destinations across all continents with our carefully curated trip packages.</p>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="feature-card text-center">
                <div class="feature-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h4>Safe & Secure</h4>
                <p>Your safety is our priority. All our trips are planned with comprehensive safety measures.</p>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="feature-card text-center">
                <div class="feature-icon">
                    <i class="fas fa-headset"></i>
                </div>
                <h4>24/7 Support</h4>
                <p>Our dedicated support team is available round the clock to assist you during your journey.</p>
            </div>
        </div>
    </div>
    
    <div class="row mt-5">
        <div class="col-12 text-center">
            <h3>Ready to Start Your Adventure?</h3>
            <p class="lead mb-4">Browse our exciting trip packages and book your next adventure today!</p>
            <a href="${pageContext.request.contextPath}/trips" class="btn btn-primary btn-lg">
                <i class="fas fa-plane"></i> View All Trips
            </a>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>