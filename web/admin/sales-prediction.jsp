<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Prediction - Admin Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
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
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/sales-prediction">
                                <i class="fas fa-chart-line"></i> Sales Prediction
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
            
            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-chart-line"></i> Sales Prediction Analysis</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button class="btn btn-outline-secondary" onclick="window.location.reload()">
                            <i class="fas fa-sync-alt"></i> Refresh Analysis
                        </button>
                    </div>
                </div>
                
                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle"></i> ${error}
                    </div>
                </c:if>
                
                <!-- Warning Message for Fallback Mode -->
                <c:if test="${not empty warning}">
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-circle"></i> <strong>Note:</strong> ${warning}
                        <br><small>The system is using a simplified prediction model. For full Weka functionality, ensure all dependencies are properly installed.</small>
                    </div>
                </c:if>
                
                <!-- Prediction Results -->
                <c:if test="${not empty predictionResults}">
                    <!-- Summary Cards -->
                    <div class="row mb-4">
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-primary">
                                <div class="card-body">
                                    <div class="d-flex align-items-center">
                                        <div class="flex-grow-1">
                                            <div class="text-muted small">Predicted Annual Revenue</div>
                                            <div class="h4 mb-0">£<fmt:formatNumber value="${predictionResults.totalPredictedRevenue}" pattern="#,##0"/></div>
                                        </div>
                                        <div class="flex-shrink-0">
                                            <i class="fas fa-pound-sign fa-2x text-primary"></i>
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
                                            <div class="text-muted small">With 10% Inc. Advertising</div>
                                            <div class="h4 mb-0">£<fmt:formatNumber value="${predictionResults.totalIncreasedRevenue}" pattern="#,##0"/></div>
                                        </div>
                                        <div class="flex-shrink-0">
                                            <i class="fas fa-arrow-up fa-2x text-success"></i>
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
                                            <div class="text-muted small">Additional Revenue</div>
                                            <div class="h4 mb-0">£<fmt:formatNumber value="${predictionResults.revenueIncrease}" pattern="#,##0"/></div>
                                        </div>
                                        <div class="flex-shrink-0">
                                            <i class="fas fa-plus fa-2x text-info"></i>
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
                                            <div class="text-muted small">ROI on Additional Advertising</div>
                                            <div class="h4 mb-0"><fmt:formatNumber value="${predictionResults.roi}" pattern="#,##0.0"/>%</div>
                                        </div>
                                        <div class="flex-shrink-0">
                                            <i class="fas fa-percentage fa-2x text-warning"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Business Recommendation -->
                    <div class="alert ${predictionResults.roi > 100 ? 'alert-success' : 'alert-warning'} mb-4">
                        <h5><i class="fas fa-lightbulb"></i> Business Recommendation</h5>
                        <p class="mb-0">${predictionResults.recommendation}</p>
                    </div>
                    
                    <!-- Chart -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="fas fa-chart-bar"></i> Monthly Revenue Predictions for 2024</h5>
                                </div>
                                <div class="card-body">
                                    <canvas id="revenueChart" style="height: 400px;"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Detailed Table -->
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="fas fa-table"></i> Detailed Monthly Predictions</h5>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-striped table-hover">
                                            <thead class="table-dark">
                                                <tr>
                                                    <th>Month</th>
                                                    <th>Advertising Cost</th>
                                                    <th>Predicted Revenue</th>
                                                    <th>10% Increased Cost</th>
                                                    <th>Revenue with Increase</th>
                                                    <th>Additional Revenue</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="month" items="${predictionResults.monthlyPredictions}">
                                                    <tr>
                                                        <td><strong>${month.month}</strong></td>
                                                        <td>£<fmt:formatNumber value="${month.advertisingCost}" pattern="#,##0"/></td>
                                                        <td>£<fmt:formatNumber value="${month.predictedRevenue}" pattern="#,##0"/></td>
                                                        <td>£<fmt:formatNumber value="${month.increasedCost}" pattern="#,##0"/></td>
                                                        <td>£<fmt:formatNumber value="${month.increasedRevenue}" pattern="#,##0"/></td>
                                                        <td class="text-success">
                                                            +£<fmt:formatNumber value="${month.increasedRevenue - month.predictedRevenue}" pattern="#,##0"/>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                            <tfoot class="table-secondary">
                                                <tr>
                                                    <th>TOTAL</th>
                                                    <th>£<fmt:formatNumber value="${predictionResults.totalAdvertisingCost}" pattern="#,##0"/></th>
                                                    <th>£<fmt:formatNumber value="${predictionResults.totalPredictedRevenue}" pattern="#,##0"/></th>
                                                    <th>£<fmt:formatNumber value="${predictionResults.totalAdvertisingCost * 1.1}" pattern="#,##0"/></th>
                                                    <th>£<fmt:formatNumber value="${predictionResults.totalIncreasedRevenue}" pattern="#,##0"/></th>
                                                    <th class="text-success">
                                                        +£<fmt:formatNumber value="${predictionResults.revenueIncrease}" pattern="#,##0"/>
                                                    </th>
                                                </tr>
                                            </tfoot>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Technical Details -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="fas fa-cogs"></i> Technical Details</h5>
                                </div>
                                <div class="card-body">
                                    <p><strong>Model:</strong> Linear Regression using Weka Machine Learning Library</p>
                                    <p><strong>Training Data:</strong> 12 months of historical data (2023)</p>
                                    <p><strong>Features:</strong> Year, Month, Advertising Cost</p>
                                    <p><strong>Target:</strong> Revenue</p>
                                    <p><strong>Prediction Period:</strong> 2024 (12 months ahead)</p>
                                    <p class="mb-0"><strong>Scenario Analysis:</strong> Baseline vs 10% increased advertising spend</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </main>
        </div>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    
    <!-- Chart Script -->
    <c:if test="${not empty predictionResults}">
    <script>
        // Prepare data for chart
        const monthLabels = [<c:forEach var="month" items="${predictionResults.monthlyPredictions}" varStatus="status">'${month.month}'<c:if test="${!status.last}">,</c:if></c:forEach>];
        const predictedData = [<c:forEach var="month" items="${predictionResults.monthlyPredictions}" varStatus="status">${month.predictedRevenue}<c:if test="${!status.last}">,</c:if></c:forEach>];
        const increasedData = [<c:forEach var="month" items="${predictionResults.monthlyPredictions}" varStatus="status">${month.increasedRevenue}<c:if test="${!status.last}">,</c:if></c:forEach>];
        
        // Create chart
        const ctx = document.getElementById('revenueChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: monthLabels,
                datasets: [{
                    label: 'Predicted Revenue',
                    data: predictedData,
                    backgroundColor: 'rgba(54, 162, 235, 0.8)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }, {
                    label: 'Revenue with 10% Inc. Advertising',
                    data: increasedData,
                    backgroundColor: 'rgba(75, 192, 192, 0.8)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '£' + value.toLocaleString();
                            }
                        }
                    }
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.dataset.label + ': £' + context.parsed.y.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
    </script>
    </c:if>
</body>
</html>