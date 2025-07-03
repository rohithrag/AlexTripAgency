// File: src/java/com/tripagency/controller/TripListServlet.java
package controller;

import dao.TripDAO;
import model.Trip;
import dao.TripDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import model.Trip;

@WebServlet("/trips")
public class TripListServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String destination = request.getParameter("destination");
            String activityType = request.getParameter("activityType");
            String maxPriceStr = request.getParameter("maxPrice");
            String maxDurationStr = request.getParameter("maxDuration");
            
            List<Trip> trips;
            
            // Check if it's a search request
            if (destination != null || activityType != null || 
                maxPriceStr != null || maxDurationStr != null) {
                
                BigDecimal maxPrice = null;
                Integer maxDuration = null;
                
                if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
                    try {
                        maxPrice = new BigDecimal(maxPriceStr);
                    } catch (NumberFormatException e) {
                        // Invalid price format, ignore
                    }
                }
                
                if (maxDurationStr != null && !maxDurationStr.trim().isEmpty()) {
                    try {
                        maxDuration = Integer.parseInt(maxDurationStr);
                    } catch (NumberFormatException e) {
                        // Invalid duration format, ignore
                    }
                }
                
                trips = tripDAO.searchTrips(destination, activityType, maxPrice, maxDuration);
            } else {
                trips = tripDAO.getAllTrips();
            }
            
            // Get filter options for the form
            List<String> destinations = tripDAO.getDistinctDestinations();
            List<String> activityTypes = tripDAO.getDistinctActivityTypes();
            
            request.setAttribute("trips", trips);
            request.setAttribute("destinations", destinations);
            request.setAttribute("activityTypes", activityTypes);
            
            request.getRequestDispatcher("/trips.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Database error occurred");
        }
    }
}