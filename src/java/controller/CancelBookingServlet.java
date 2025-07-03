package controller;

import dao.BookingDAO;
import dao.TripDAO;
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
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/user/cancel-booking")
public class CancelBookingServlet extends HttpServlet {
    private BookingDAO bookingDAO = new BookingDAO();
    private TripDAO tripDAO = new TripDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check user authentication
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("../login?error=Please login to cancel bookings");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("../login?error=Please login to cancel bookings");
            return;
        }
        
        // Redirect admin users - they shouldn't use this endpoint
        if ("ADMIN".equals(user.getRole())) {
            response.sendRedirect("../admin/dashboard");
            return;
        }
        
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            response.sendRedirect("dashboard?error=Invalid booking ID");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            
            // Get booking details
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                response.sendRedirect("dashboard?error=Booking not found");
                return;
            }
            
            // Check if user owns this booking
            if (booking.getUserId() != user.getUserId()) {
                response.sendRedirect("dashboard?error=You can only cancel your own bookings");
                return;
            }
            
            // Check if booking can be cancelled
            String canCancelResult = canCancelBooking(booking);
            if (!canCancelResult.equals("OK")) {
                response.sendRedirect("dashboard?error=" + canCancelResult);
                return;
            }
            
            // Cancel the booking
            boolean success = bookingDAO.cancelBooking(bookingId);
            
            if (success) {
                // Restore available spots for the trip
                tripDAO.restoreAvailableSpots(booking.getTripId(), booking.getParticipants());
                
                response.sendRedirect("dashboard?success=Booking cancelled successfully. Available spots have been restored.");
            } else {
                response.sendRedirect("dashboard?error=Failed to cancel booking. Please try again or contact support.");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard?error=Invalid booking ID format");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard?error=Database error occurred. Please try again.");
        }
    }
    
    /**
     * Check if a booking can be cancelled based on business rules
     */
    private String canCancelBooking(Booking booking) {
        // Rule 1: Cannot cancel already cancelled bookings
        if ("CANCELLED".equals(booking.getStatus())) {
            return "This booking is already cancelled";
        }
        
        // Rule 2: Calculate days until travel date
        LocalDate today = LocalDate.now();
        LocalDate travelDate = booking.getBookingDate();
        
        if (travelDate != null) {
            long daysUntilTravel = ChronoUnit.DAYS.between(today, travelDate);
            
            // Rule 3: Must cancel at least 2 days before travel date
            if (daysUntilTravel < 2) {
                return "Cannot cancel bookings less than 2 days before travel date";
            }
            
            // Rule 4: Cannot cancel past travel dates
            if (daysUntilTravel < 0) {
                return "Cannot cancel bookings for past travel dates";
            }
        }
        
        // Rule 5: Different cancellation rules based on status
        switch (booking.getStatus()) {
            case "PENDING":
                return "OK"; // Can always cancel pending bookings
            case "CONFIRMED":
                return "OK"; // Can cancel confirmed bookings with notice
            default:
                return "Cannot cancel booking with status: " + booking.getStatus();
        }
    }
}