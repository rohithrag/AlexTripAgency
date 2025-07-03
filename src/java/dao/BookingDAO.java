package dao;

import model.Booking;
import model.Traveller;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {
    
    public int createBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO bookings (trip_id, user_id, customer_name, customer_email, " +
                    "customer_phone, participants, total_amount, booking_date) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, booking.getTripId());
            pstmt.setInt(2, booking.getUserId());
            pstmt.setString(3, booking.getCustomerName());
            pstmt.setString(4, booking.getCustomerEmail());
            pstmt.setString(5, booking.getCustomerPhone());
            pstmt.setInt(6, booking.getParticipants());
            pstmt.setBigDecimal(7, booking.getTotalAmount());
            pstmt.setDate(8, Date.valueOf(booking.getBookingDate()));
            
            int result = pstmt.executeUpdate();
            if (result > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        }
        return -1;
    }
    
    public boolean addTravellers(List<Traveller> travellers) throws SQLException {
        String sql = "INSERT INTO travellers (booking_id, name, age, gender, passport_number) " +
                    "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            for (Traveller traveller : travellers) {
                pstmt.setInt(1, traveller.getBookingId());
                pstmt.setString(2, traveller.getName());
                pstmt.setInt(3, traveller.getAge());
                pstmt.setString(4, traveller.getGender());
                pstmt.setString(5, traveller.getPassportNumber());
                pstmt.addBatch();
            }
            
            int[] results = pstmt.executeBatch();
            for (int result : results) {
                if (result <= 0) return false;
            }
            return true;
        }
    }
    
    public List<Booking> getAllBookings() throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, t.title as trip_title, t.destination as trip_destination " +
                    "FROM bookings b " +
                    "LEFT JOIN trips t ON b.trip_id = t.trip_id " +
                    "ORDER BY b.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                bookings.add(mapResultSetToBooking(rs));
            }
        }
        return bookings;
    }
    
    public List<Booking> getBookingsByUser(int userId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, t.title as trip_title, t.destination as trip_destination " +
                    "FROM bookings b " +
                    "LEFT JOIN trips t ON b.trip_id = t.trip_id " +
                    "WHERE b.user_id = ? " +
                    "ORDER BY b.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
        }
        return bookings;
    }
    
    public Booking getBookingById(int bookingId) throws SQLException {
        String sql = "SELECT b.*, t.title as trip_title, t.destination as trip_destination " +
                    "FROM bookings b " +
                    "LEFT JOIN trips t ON b.trip_id = t.trip_id " +
                    "WHERE b.booking_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bookingId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBooking(rs);
                }
            }
        }
        return null;
    }
    
    // NEW METHOD: Cancel booking
    public boolean cancelBooking(int bookingId) throws SQLException {
        String sql = "UPDATE bookings SET status = 'CANCELLED', updated_at = CURRENT_TIMESTAMP WHERE booking_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bookingId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    // NEW METHOD: Update booking status
    public boolean updateBookingStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE bookings SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE booking_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, bookingId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getInt("booking_id"));
        booking.setTripId(rs.getInt("trip_id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setCustomerName(rs.getString("customer_name"));
        booking.setCustomerEmail(rs.getString("customer_email"));
        booking.setCustomerPhone(rs.getString("customer_phone"));
        booking.setParticipants(rs.getInt("participants"));
        booking.setTotalAmount(rs.getBigDecimal("total_amount"));
        
        Date bookingDate = rs.getDate("booking_date");
        if (bookingDate != null) {
            booking.setBookingDate(bookingDate.toLocalDate());
        }
        
        booking.setStatus(rs.getString("status"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            booking.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        // Set trip information if available
        booking.setTripTitle(rs.getString("trip_title"));
        booking.setTripDestination(rs.getString("trip_destination"));
        
        return booking;
    }
}