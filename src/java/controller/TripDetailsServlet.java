// File: src/java/com/tripagency/controller/TripDetailsServlet.java
package controller;

import dao.TripDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import model.Trip;

@WebServlet("/trip-details")
public class TripDetailsServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String tripIdStr = request.getParameter("id");
        
        if (tripIdStr == null || tripIdStr.trim().isEmpty()) {
            response.sendRedirect("trips");
            return;
        }
        
        try {
            int tripId = Integer.parseInt(tripIdStr);
            Trip trip = tripDAO.getTripById(tripId);
            
            if (trip == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Trip not found");
                return;
            }
            
            request.setAttribute("trip", trip);
            request.getRequestDispatcher("/trip-details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid trip ID");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Database error occurred");
        }
    }
}