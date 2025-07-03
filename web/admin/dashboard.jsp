<!-- File: web/admin/dashboard.jsp (UPDATED WITH SALES PREDICTION) -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Alex's Trip Agency</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Admin Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-plane"></i> Alex's Trip Agency - Admin
            </a>
            
            <div class="navbar-nav ms-auto">
                <div class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user"></i> ${sessionScope.user.username}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/">
                            <i class="fas fa-globe"></i> View Website</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/logout">
                            <i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>
    
    <div class="container-fluid">
        <div class="row">
            <!-- Updated Sidebar with Sales Prediction -->
            <nav class="col-md-3 col-lg-2 d-md-block bg-light sidebar">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/trips">
                                <i class="fas fa-map-marked-alt"></i> Manage Trips
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/add-trip">
                                <i class="fas fa-plus"></i> Add New Trip
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/bookings">
                                <i class="fas fa-calendar-check"></i> View Bookings
                            </a>
                        </li>
                        <!-- NEW: Sales Prediction Link -->
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/sales-prediction">
                                <i class="fas fa-chart-line"></i> Sales Prediction
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
            
            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-tachometer-alt"></i> Dashboard</h1>
                </div>
                
                <!-- Welcome Message -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="alert alert-info">
                            <h5><i class="fas fa-user-shield"></i> Welcome, ${sessionScope.user.username}!</h5>
                            <p class="mb-0">You are logged in as an administrator. Use the navigation menu to manage trips and bookings.</p>
                        </div>
                    </div>
                </div>
                
                <!-- Dashboard Stats -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-primary">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <div class="text-muted small">Total Trips</div>
                                        <div class="h4 mb-0">12</div>
                                    </div>
                                    <div class="flex-shrink-0">
                                        <i class="fas fa-map-marked-alt fa-2x text-primary"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-success">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <div class="text-muted small">Total Bookings</div>
                                        <div class="h4 mb-0">45</div>
                                    </div>
                                    <div class="flex-shrink-0">
                                        <i class="fas fa-calendar-check fa-2x text-success"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-info">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <div class="text-muted small">Available Spots</div>
                                        <div class="h4 mb-0">187</div>
                                    </div>
                                    <div class="flex-shrink-0">
                                        <i class="fas fa-users fa-2x text-info"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-warning">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <div class="text-muted small">Revenue</div>
                                        <div class="h4 mb-0">£54,320</div>
                                    </div>
                                    <div class="flex-shrink-0">
                                        <i class="fas fa-pound-sign fa-2x text-warning"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Updated Quick Actions with Sales Prediction -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-bolt"></i> Quick Actions</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-lg-3 col-md-6 mb-2">
                                        <a href="${pageContext.request.contextPath}/admin/add-trip" 
                                           class="btn btn-primary w-100">
                                            <i class="fas fa-plus"></i> Add New Trip
                                        </a>
                                    </div>
                                    <div class="col-lg-3 col-md-6 mb-2">
                                        <a href="${pageContext.request.contextPath}/admin/trips" 
                                           class="btn btn-info w-100">
                                            <i class="fas fa-edit"></i> Manage Trips
                                        </a>
                                    </div>
                                    <div class="col-lg-3 col-md-6 mb-2">
                                        <a href="${pageContext.request.contextPath}/admin/bookings" 
                                           class="btn btn-success w-100">
                                            <i class="fas fa-calendar-check"></i> View Bookings
                                        </a>
                                    </div>
                                    <!-- NEW: Sales Prediction Quick Action -->
                                    <div class="col-lg-3 col-md-6 mb-2">
                                        <a href="${pageContext.request.contextPath}/admin/sales-prediction" 
                                           class="btn btn-warning w-100">
                                            <i class="fas fa-chart-line"></i> Sales Prediction
                                        </a>
                                    </div>
                                </div>
                                <div class="row mt-2">
                                    <div class="col-lg-3 col-md-6 mb-2">
                                        <a href="${pageContext.request.contextPath}/" 
                                           class="btn btn-secondary w-100" target="_blank">
                                            <i class="fas fa-globe"></i> View Website
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Recent Activity -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-clock"></i> Recent Activity</h5>
                            </div>
                            <div class="card-body">
                                <div class="list-group list-group-flush">
                                    <div class="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <span class="badge bg-success me-2">New Booking</span>
                                            Himalayan Adventure - John Doe
                                        </div>
                                        <small class="text-muted">2 hours ago</small>
                                    </div>
                                    <div class="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <span class="badge bg-primary me-2">Trip Updated</span>
                                            Paris City Break - Price updated
                                        </div>
                                        <small class="text-muted">5 hours ago</small>
                                    </div>
                                    <div class="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <span class="badge bg-info me-2">New Trip</span>
                                            Bali Relaxation added
                                        </div>
                                        <small class="text-muted">1 day ago</small>
                                    </div>
                                    <div class="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <span class="badge bg-warning me-2">AI Analysis</span>
                                            Sales prediction model updated
                                        </div>
                                        <small class="text-muted">1 day ago</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>