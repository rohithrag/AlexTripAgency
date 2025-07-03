// File: src/java/com/tripagency/controller/BookingConfirmationServlet.java
package controller;

import dao.BookingDAO;
import dao.TripDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Booking;
import model.Trip;
import java.io.IOException;
import java.sql.SQLException;


@WebServlet("/booking-confirmation")
public class BookingConfirmationServlet extends HttpServlet {
    private BookingDAO bookingDAO = new BookingDAO();
    private TripDAO tripDAO = new TripDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            response.sendRedirect("trips");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
                return;
            }
            
            Trip trip = tripDAO.getTripById(booking.getTripId());
            
            request.setAttribute("booking", booking);
            request.setAttribute("trip", trip);
            request.getRequestDispatcher("/booking-confirmation.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking ID");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Database error occurred");
        }
    }
}