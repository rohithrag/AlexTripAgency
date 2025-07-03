// File: src/java/com/tripagency/controller/TripApiServlet.java
package controller;

import dao.TripDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Trip;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;


@WebServlet("/api/trips/*")
public class TripApiServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getPathInfo();
        PrintWriter out = response.getWriter();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Handle search parameters
                String destination = request.getParameter("destination");
                String activityType = request.getParameter("activityType");
                String maxPriceStr = request.getParameter("maxPrice");
                String maxDurationStr = request.getParameter("maxDuration");
                
                List<Trip> trips;
                
                if (destination != null || activityType != null || 
                    maxPriceStr != null || maxDurationStr != null) {
                    
                    BigDecimal maxPrice = null;
                    Integer maxDuration = null;
                    
                    if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
                        try {
                            maxPrice = new BigDecimal(maxPriceStr);
                        } catch (NumberFormatException e) {
                            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                            out.print("{\"error\":\"Invalid price format\"}");
                            return;
                        }
                    }
                    
                    if (maxDurationStr != null && !maxDurationStr.trim().isEmpty()) {
                        try {
                            maxDuration = Integer.parseInt(maxDurationStr);
                        } catch (NumberFormatException e) {
                            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                            out.print("{\"error\":\"Invalid duration format\"}");
                            return;
                        }
                    }
                    
                    trips = tripDAO.searchTrips(destination, activityType, maxPrice, maxDuration);
                } else {
                    trips = tripDAO.getAllTrips();
                }
                
                out.print(convertTripsToJson(trips));
                
            } else {
                // Handle specific trip ID
                String[] pathParts = pathInfo.split("/");
                if (pathParts.length >= 2) {
                    try {
                        int tripId = Integer.parseInt(pathParts[1]);
                        Trip trip = tripDAO.getTripById(tripId);
                        
                        if (trip != null) {
                            out.print(convertTripToJson(trip));
                        } else {
                            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                            out.print("{\"error\":\"Trip not found\"}");
                        }
                    } catch (NumberFormatException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print("{\"error\":\"Invalid trip ID\"}");
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\":\"Invalid request path\"}");
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Database error occurred\"}");
        }
    }
    
    private String convertTripsToJson(List<Trip> trips) {
        StringBuilder json = new StringBuilder();
        json.append("[");
        
        for (int i = 0; i < trips.size(); i++) {
            if (i > 0) json.append(",");
            json.append(convertTripToJson(trips.get(i)));
        }
        
        json.append("]");
        return json.toString();
    }
    
    private String convertTripToJson(Trip trip) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"tripId\":").append(trip.getTripId()).append(",");
        json.append("\"title\":\"").append(escapeJson(trip.getTitle())).append("\",");
        json.append("\"description\":\"").append(escapeJson(trip.getDescription())).append("\",");
        json.append("\"destination\":\"").append(escapeJson(trip.getDestination())).append("\",");
        json.append("\"duration\":").append(trip.getDuration()).append(",");
        json.append("\"price\":").append(trip.getPrice()).append(",");
        json.append("\"activityType\":\"").append(escapeJson(trip.getActivityType())).append("\",");
        json.append("\"maxParticipants\":").append(trip.getMaxParticipants()).append(",");
        json.append("\"availableSpots\":").append(trip.getAvailableSpots()).append(",");
        
        if (trip.getStartDate() != null) {
            json.append("\"startDate\":\"").append(trip.getStartDate().toString()).append("\",");
        }
        if (trip.getEndDate() != null) {
            json.append("\"endDate\":\"").append(trip.getEndDate().toString()).append("\",");
        }
        
        json.append("\"imageUrl\":\"").append(escapeJson(trip.getImageUrl())).append("\",");
        json.append("\"status\":\"").append(escapeJson(trip.getStatus())).append("\"");
        json.append("}");
        
        return json.toString();
    }
    
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}