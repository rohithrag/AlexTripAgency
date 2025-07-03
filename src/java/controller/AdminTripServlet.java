// File: src/java/com/tripagency/controller/AdminTripServlet.java (UPDATED)
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
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/trips")
public class AdminTripServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin authentication
        if (!isAdminAuthenticated(request)) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            List<Trip> trips = tripDAO.getAllTrips();
            request.setAttribute("trips", trips);
            request.getRequestDispatcher("/admin/manage-trips.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Database error occurred");
        }
    }
    
    private boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }
}