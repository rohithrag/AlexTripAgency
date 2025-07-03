package controller;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.User;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;


@WebServlet("/user/dashboard")
public class UserDashboardServlet extends HttpServlet {
    private BookingDAO bookingDAO = new BookingDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check user authentication
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("../login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("../login");
            return;
        }
        
        // Redirect admin users to admin dashboard
        if ("ADMIN".equals(user.getRole())) {
            response.sendRedirect("../admin/dashboard");
            return;
        }
        
        try {
            // Get user's bookings
            List<Booking> userBookings = bookingDAO.getBookingsByUser(user.getUserId());
            request.setAttribute("bookings", userBookings);
            request.getRequestDispatcher("/user/dashboard.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Database error occurred");
        }
    }
}