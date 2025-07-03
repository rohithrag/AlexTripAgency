package controller;

import dao.BookingDAO;
import dao.TripDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import model.Booking;
import model.Traveller;
import model.Trip;
import model.User;
import util.ValidationUtil;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();
    private BookingDAO bookingDAO = new BookingDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String tripIdStr = request.getParameter("tripId");
        
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
            request.getRequestDispatcher("/booking.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid trip ID");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Database error occurred");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in for booking
        HttpSession session = request.getSession(false);
        User currentUser = null;
        int userId = 0; // Default to 0 for guest bookings
        
        if (session != null && session.getAttribute("user") != null) {
            currentUser = (User) session.getAttribute("user");
            userId = currentUser.getUserId();
        }
        
        try {
            // Get trip information
            int tripId = Integer.parseInt(request.getParameter("tripId"));
            Trip trip = tripDAO.getTripById(tripId);
            
            if (trip == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Trip not found");
                return;
            }
            
            // Get booking information
            String customerName = request.getParameter("customerName");
            String customerEmail = request.getParameter("customerEmail");
            String customerPhone = request.getParameter("customerPhone");
            int participants = Integer.parseInt(request.getParameter("participants"));
            String bookingDateStr = request.getParameter("bookingDate");
            
            // If user is logged in, pre-fill customer info from user profile
            if (currentUser != null) {
                if (customerName == null || customerName.trim().isEmpty()) {
                    customerName = currentUser.getFullName() != null ? currentUser.getFullName() : currentUser.getUsername();
                }
                if (customerEmail == null || customerEmail.trim().isEmpty()) {
                    customerEmail = currentUser.getEmail();
                }
                if (customerPhone == null || customerPhone.trim().isEmpty()) {
                    customerPhone = currentUser.getPhone();
                }
            }
            
            // Validate input
            List<String> errors = validateBookingInput(customerName, customerEmail, 
                                                     customerPhone, participants, 
                                                     bookingDateStr, trip);
            
            if (!errors.isEmpty()) {
                request.setAttribute("trip", trip);
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("/booking.jsp").forward(request, response);
                return;
            }
            
            // Parse booking date
            LocalDate bookingDate = LocalDate.parse(bookingDateStr, 
                                                   DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            
            // Calculate total amount
            BigDecimal totalAmount = trip.getPrice().multiply(new BigDecimal(participants));
            
            // Create booking with user ID
            Booking booking = new Booking(tripId, userId, customerName, customerEmail, 
                                        customerPhone, participants, totalAmount, bookingDate);
            
            int bookingId = bookingDAO.createBooking(booking);
            
            if (bookingId > 0) {
                // Get traveller information
                List<Traveller> travellers = new ArrayList<>();
                for (int i = 1; i <= participants; i++) {
                    String name = request.getParameter("traveller" + i + "Name");
                    String ageStr = request.getParameter("traveller" + i + "Age");
                    String gender = request.getParameter("traveller" + i + "Gender");
                    String passport = request.getParameter("traveller" + i + "Passport");
                    
                    if (name != null && !name.trim().isEmpty()) {
                        int age = 0;
                        try {
                            age = Integer.parseInt(ageStr);
                        } catch (NumberFormatException e) {
                            // Default age
                        }
                        
                        Traveller traveller = new Traveller(bookingId, name, age, gender, passport);
                        travellers.add(traveller);
                    }
                }
                
                // Add travellers
                if (!travellers.isEmpty()) {
                    bookingDAO.addTravellers(travellers);
                }
                
                // Update available spots
                tripDAO.updateAvailableSpots(tripId, participants);
                
                // Redirect to confirmation page
                response.sendRedirect("booking-confirmation?bookingId=" + bookingId);
            } else {
                request.setAttribute("trip", trip);
                request.setAttribute("error", "Failed to create booking. Please try again.");
                request.getRequestDispatcher("/booking.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input format");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Database error occurred");
        }
    }
    
    private List<String> validateBookingInput(String customerName, String customerEmail, 
                                            String customerPhone, int participants, 
                                            String bookingDateStr, Trip trip) {
        List<String> errors = new ArrayList<>();
        
        if (customerName == null || customerName.trim().isEmpty()) {
            errors.add("Customer name is required");
        }
        
        if (customerEmail == null || customerEmail.trim().isEmpty()) {
            errors.add("Customer email is required");
        } else if (!ValidationUtil.isValidEmail(customerEmail)) {
            errors.add("Please enter a valid email address");
        }
        
        if (participants <= 0) {
            errors.add("Number of participants must be greater than 0");
        } else if (participants > trip.getAvailableSpots()) {
            errors.add("Not enough available spots. Only " + trip.getAvailableSpots() + " spots left");
        }
        
        if (bookingDateStr == null || bookingDateStr.trim().isEmpty()) {
            errors.add("Booking date is required");
        } else {
            try {
                LocalDate bookingDate = LocalDate.parse(bookingDateStr, 
                                                       DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                if (bookingDate.isBefore(trip.getStartDate())) {
                    errors.add("Booking date cannot be before trip start date");
                }
                if (bookingDate.isAfter(trip.getEndDate())) {
                    errors.add("Booking date cannot be after trip end date");
                }
            } catch (DateTimeParseException e) {
                errors.add("Invalid booking date format");
            }
        }
        
        return errors;
    }
}