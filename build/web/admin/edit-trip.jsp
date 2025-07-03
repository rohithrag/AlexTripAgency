
<!-- File: web/admin/edit-trip.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Trip - Admin Dashboard</title>
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
                    <h1 class="h2"><i class="fas fa-edit"></i> Edit Trip</h1>
                    <a href="${pageContext.request.contextPath}/admin/trips" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Trips
                    </a>
                </div>
                
                <!-- Error Messages -->
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
                
                <!-- Trip Form -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Trip Details</h5>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="${pageContext.request.contextPath}/admin/edit-trip">
                            <input type="hidden" name="tripId" value="${trip.tripId}">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <label for="title" class="form-label">Trip Title *</label>
                                    <input type="text" class="form-control" id="title" name="title" 
                                           value="${trip.title}" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="destination" class="form-label">Destination *</label>
                                    <input type="text" class="form-control" id="destination" name="destination" 
                                           value="${trip.destination}" required>
                                </div>
                            </div>
                            
                            <div class="row mt-3">
                                <div class="col-md-3">
                                    <label for="duration" class="form-label">Duration (days) *</label>
                                    <input type="number" class="form-control" id="duration" name="duration" 
                                           value="${trip.duration}" min="1" required>
                                </div>
                                <div class="col-md-3">
                                    <label for="price" class="form-label">Price per Person (£) *</label>
                                    <input type="number" class="form-control" id="price" name="price" 
                                           value="${trip.price}" step="0.01" min="0" required>
                                </div>
                                <div class="col-md-3">
                                    <label for="maxParticipants" class="form-label">Max Participants *</label>
                                    <input type="number" class="form-control" id="maxParticipants" name="maxParticipants" 
                                           value="${trip.maxParticipants}" min="1" required>
                                </div>
                                <div class="col-md-3">
                                    <label for="availableSpots" class="form-label">Available Spots *</label>
                                    <input type="number" class="form-control" id="availableSpots" name="availableSpots" 
                                           value="${trip.availableSpots}" min="0" required>
                                </div>
                            </div>
                            
                            <div class="row mt-3">
                                <div class="col-md-6">
                                    <label for="activityType" class="form-label">Activity Type *</label>
                                    <select class="form-select" id="activityType" name="activityType" required>
                                        <option value="">Select Activity Type</option>
                                        <option value="Adventure" ${trip.activityType == 'Adventure' ? 'selected' : ''}>Adventure</option>
                                        <option value="Cultural" ${trip.activityType == 'Cultural' ? 'selected' : ''}>Cultural</option>
                                        <option value="Wildlife" ${trip.activityType == 'Wildlife' ? 'selected' : ''}>Wildlife</option>
                                        <option value="Relaxation" ${trip.activityType == 'Relaxation' ? 'selected' : ''}>Relaxation</option>
                                        <option value="Educational" ${trip.activityType == 'Educational' ? 'selected' : ''}>Educational</option>
                                        <option value="Business" ${trip.activityType == 'Business' ? 'selected' : ''}>Business</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="imageUrl" class="form-label">Image URL</label>
                                    <input type="url" class="form-control" id="imageUrl" name="imageUrl" 
                                           value="${trip.imageUrl}" placeholder="https://example.com/image.jpg">
                                </div>
                            </div>
                            
                            <div class="row mt-3">
                                <div class="col-md-6">
                                    <label for="startDate" class="form-label">Start Date *</label>
                                    <input type="date" class="form-control" id="startDate" name="startDate" 
                                           value="${trip.startDate}" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="endDate" class="form-label">End Date *</label>
                                    <input type="date" class="form-control" id="endDate" name="endDate" 
                                           value="${trip.endDate}" required>
                                </div>
                            </div>
                            
                            <div class="mt-3">
                                <label for="description" class="form-label">Description *</label>
                                <textarea class="form-control" id="description" name="description" 
                                          rows="4" required>${trip.description}</textarea>
                            </div>
                            
                            <div class="mt-4">
                                <button type="submit" class="btn btn-primary me-2">
                                    <i class="fas fa-save"></i> Update Trip
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/trips" class="btn btn-secondary">
                                    Cancel
                                </a>
                                <a href="${pageContext.request.contextPath}/trip-details?id=${trip.tripId}" 
                                   class="btn btn-outline-info ms-3" target="_blank">
                                    <i class="fas fa-eye"></i> Preview Trip
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        // Date validation
        document.getElementById('startDate').addEventListener('change', function() {
            const startDate = this.value;
            const endDateField = document.getElementById('endDate');
            endDateField.min = startDate;
            
            if (endDateField.value && endDateField.value < startDate) {
                endDateField.value = startDate;
            }
        });
        
        // Max participants vs available spots validation
        document.getElementById('maxParticipants').addEventListener('change', function() {
            const maxParticipants = parseInt(this.value);
            const availableSpotsField = document.getElementById('availableSpots');
            availableSpotsField.max = maxParticipants;
            
            if (parseInt(availableSpotsField.value) > maxParticipants) {
                availableSpotsField.value = maxParticipants;
            }
        });
    </script>
</body>
</html>