package controller;

import dao.TripDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Trip;
import model.User;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;


@WebServlet("/admin/edit-trip")
public class EditTripServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin authentication
        if (!isAdminAuthenticated(request)) {
            response.sendRedirect("login");
            return;
        }
        
        String tripIdStr = request.getParameter("id");
        if (tripIdStr == null || tripIdStr.trim().isEmpty()) {
            response.sendRedirect("trips?error=Trip ID is required");
            return;
        }
        
        try {
            int tripId = Integer.parseInt(tripIdStr);
            Trip trip = tripDAO.getTripById(tripId);
            
            if (trip == null) {
                response.sendRedirect("trips?error=Trip not found");
                return;
            }
            
            request.setAttribute("trip", trip);
            request.getRequestDispatcher("/admin/edit-trip.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("trips?error=Invalid trip ID");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Database error occurred");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin authentication
        if (!isAdminAuthenticated(request)) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            Trip trip = extractTripFromRequest(request);
            int tripId = Integer.parseInt(request.getParameter("tripId"));
            trip.setTripId(tripId);
            
            List<String> errors = validateTrip(trip);
            
            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("trip", trip);
                request.getRequestDispatcher("/admin/edit-trip.jsp").forward(request, response);
                return;
            }
            
            boolean success = tripDAO.updateTrip(trip);
            
            if (success) {
                response.sendRedirect("trips?success=Trip updated successfully");
            } else {
                request.setAttribute("error", "Failed to update trip");
                request.setAttribute("trip", trip);
                request.getRequestDispatcher("/admin/edit-trip.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Database error occurred");
        }
    }
    
    private Trip extractTripFromRequest(HttpServletRequest request) {
        Trip trip = new Trip();
        trip.setTitle(request.getParameter("title"));
        trip.setDescription(request.getParameter("description"));
        trip.setDestination(request.getParameter("destination"));
        
        try {
            trip.setDuration(Integer.parseInt(request.getParameter("duration")));
        } catch (NumberFormatException e) {
            trip.setDuration(0);
        }
        
        try {
            trip.setPrice(new BigDecimal(request.getParameter("price")));
        } catch (NumberFormatException e) {
            trip.setPrice(BigDecimal.ZERO);
        }
        
        trip.setActivityType(request.getParameter("activityType"));
        
        try {
            trip.setMaxParticipants(Integer.parseInt(request.getParameter("maxParticipants")));
        } catch (NumberFormatException e) {
            trip.setMaxParticipants(0);
        }
        
        try {
            trip.setAvailableSpots(Integer.parseInt(request.getParameter("availableSpots")));
        } catch (NumberFormatException e) {
            trip.setAvailableSpots(trip.getMaxParticipants());
        }
        
        try {
            trip.setStartDate(LocalDate.parse(request.getParameter("startDate"), 
                                            DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        } catch (DateTimeParseException e) {
            // Handle invalid date
        }
        
        try {
            trip.setEndDate(LocalDate.parse(request.getParameter("endDate"), 
                                          DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        } catch (DateTimeParseException e) {
            // Handle invalid date
        }
        
        trip.setImageUrl(request.getParameter("imageUrl"));
        
        return trip;
    }
    
    private List<String> validateTrip(Trip trip) {
        List<String> errors = new ArrayList<>();
        
        if (trip.getTitle() == null || trip.getTitle().trim().isEmpty()) {
            errors.add("Title is required");
        }
        
        if (trip.getDescription() == null || trip.getDescription().trim().isEmpty()) {
            errors.add("Description is required");
        }
        
        if (trip.getDestination() == null || trip.getDestination().trim().isEmpty()) {
            errors.add("Destination is required");
        }
        
        if (trip.getDuration() <= 0) {
            errors.add("Duration must be greater than 0");
        }
        
        if (trip.getPrice() == null || trip.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
            errors.add("Price must be greater than 0");
        }
        
        if (trip.getActivityType() == null || trip.getActivityType().trim().isEmpty()) {
            errors.add("Activity type is required");
        }
        
        if (trip.getMaxParticipants() <= 0) {
            errors.add("Maximum participants must be greater than 0");
        }
        
        if (trip.getAvailableSpots() < 0) {
            errors.add("Available spots cannot be negative");
        }
        
        if (trip.getAvailableSpots() > trip.getMaxParticipants()) {
            errors.add("Available spots cannot exceed maximum participants");
        }
        
        if (trip.getStartDate() == null) {
            errors.add("Start date is required");
        }
        
        if (trip.getEndDate() == null) {
            errors.add("End date is required");
        }
        
        if (trip.getStartDate() != null && trip.getEndDate() != null && 
            trip.getStartDate().isAfter(trip.getEndDate())) {
            errors.add("Start date cannot be after end date");
        }
        
        return errors;
    }
    
    private boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }
}