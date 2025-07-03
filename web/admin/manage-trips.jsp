<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Trips - Admin Dashboard</title>
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
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>
    
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block bg-light sidebar">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/trips">
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
                    </ul>
                </div>
            </nav>
            
            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-map-marked-alt"></i> Manage Trips</h1>
                    <a href="${pageContext.request.contextPath}/admin/add-trip" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New Trip
                    </a>
                </div>
                
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
                
                <!-- Trips Table -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">All Trips</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty trips}">
                                <div class="text-center py-4">
                                    <i class="fas fa-map-marked-alt fa-3x text-muted mb-3"></i>
                                    <h5>No trips found</h5>
                                    <p class="text-muted">Start by adding your first trip.</p>
                                    <a href="${pageContext.request.contextPath}/admin/add-trip" 
                                       class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Add New Trip
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Title</th>
                                                <th>Destination</th>
                                                <th>Duration</th>
                                                <th>Price</th>
                                                <th>Activity</th>
                                                <th>Available Spots</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="trip" items="${trips}">
                                                <tr>
                                                    <td>${trip.tripId}</td>
                                                    <td>
                                                        <div class="fw-bold">${trip.title}</div>
                                                        <small class="text-muted">Trip #${trip.tripId}</small>
                                                    </td>
                                                    <td>
                                                        <i class="fas fa-map-marker-alt text-primary"></i>
                                                        ${trip.destination}
                                                    </td>
                                                    <td>${trip.duration} days</td>
                                                    <td>£<fmt:formatNumber value="${trip.price}" pattern="#,##0.00"/></td>
                                                    <td>
                                                        <span class="badge bg-info">${trip.activityType}</span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${trip.availableSpots > 5}">
                                                                <span class="badge bg-success">${trip.availableSpots}</span>
                                                            </c:when>
                                                            <c:when test="${trip.availableSpots > 0}">
                                                                <span class="badge bg-warning">${trip.availableSpots}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-danger">0</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${trip.status == 'ACTIVE'}">
                                                                <span class="badge bg-success">Active</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Inactive</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="${pageContext.request.contextPath}/trip-details?id=${trip.tripId}" 
                                                               class="btn btn-sm btn-outline-primary" target="_blank" title="View">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/admin/edit-trip?id=${trip.tripId}" 
                                                               class="btn btn-sm btn-outline-warning" title="Edit">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-sm btn-outline-danger" 
                                                                    onclick="deleteTrip(${trip.tripId}, '${trip.title}')" title="Delete">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the trip: <strong id="tripTitle"></strong>?</p>
                    <p class="text-danger">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDelete">Delete Trip</button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        let tripToDelete = null;
        
        function deleteTrip(tripId, tripTitle) {
            tripToDelete = tripId;
            document.getElementById('tripTitle').textContent = tripTitle;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }
        
        document.getElementById('confirmDelete').addEventListener('click', function() {
            if (tripToDelete) {
                // In a real application, this would send an AJAX request to delete the trip
                alert('Delete functionality would be implemented here for trip ID: ' + tripToDelete);
            }
        });
    </script>
</body>
</html>