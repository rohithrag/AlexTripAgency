/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Trip;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class TripDAO {
    
    public List<Trip> getAllTrips() throws SQLException {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM trips WHERE status = 'ACTIVE' ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                trips.add(mapResultSetToTrip(rs));
            }
        }
        return trips;
    }
    
    public List<Trip> searchTrips(String destination, String activityType, 
                                  BigDecimal maxPrice, Integer maxDuration) throws SQLException {
        List<Trip> trips = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM trips WHERE status = 'ACTIVE'");
        
        if (destination != null && !destination.trim().isEmpty()) {
            sql.append(" AND destination LIKE ?");
        }
        if (activityType != null && !activityType.trim().isEmpty()) {
            sql.append(" AND activity_type = ?");
        }
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
        }
        if (maxDuration != null) {
            sql.append(" AND duration <= ?");
        }
        
        sql.append(" ORDER BY created_at DESC");
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (destination != null && !destination.trim().isEmpty()) {
                pstmt.setString(paramIndex++, "%" + destination + "%");
            }
            if (activityType != null && !activityType.trim().isEmpty()) {
                pstmt.setString(paramIndex++, activityType);
            }
            if (maxPrice != null) {
                pstmt.setBigDecimal(paramIndex++, maxPrice);
            }
            if (maxDuration != null) {
                pstmt.setInt(paramIndex++, maxDuration);
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    trips.add(mapResultSetToTrip(rs));
                }
            }
        }
        return trips;
    }
    
    public Trip getTripById(int tripId) throws SQLException {
        String sql = "SELECT * FROM trips WHERE trip_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tripId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTrip(rs);
                }
            }
        }
        return null;
    }
    
    public boolean addTrip(Trip trip) throws SQLException {
        String sql = "INSERT INTO trips (title, description, destination, duration, price, " +
                    "activity_type, max_participants, available_spots, start_date, end_date, image_url) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, trip.getTitle());
            pstmt.setString(2, trip.getDescription());
            pstmt.setString(3, trip.getDestination());
            pstmt.setInt(4, trip.getDuration());
            pstmt.setBigDecimal(5, trip.getPrice());
            pstmt.setString(6, trip.getActivityType());
            pstmt.setInt(7, trip.getMaxParticipants());
            pstmt.setInt(8, trip.getAvailableSpots());
            pstmt.setDate(9, Date.valueOf(trip.getStartDate()));
            pstmt.setDate(10, Date.valueOf(trip.getEndDate()));
            pstmt.setString(11, trip.getImageUrl());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    public boolean updateTrip(Trip trip) throws SQLException {
        String sql = "UPDATE trips SET title = ?, description = ?, destination = ?, " +
                    "duration = ?, price = ?, activity_type = ?, max_participants = ?, " +
                    "available_spots = ?, start_date = ?, end_date = ?, image_url = ? " +
                    "WHERE trip_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, trip.getTitle());
            pstmt.setString(2, trip.getDescription());
            pstmt.setString(3, trip.getDestination());
            pstmt.setInt(4, trip.getDuration());
            pstmt.setBigDecimal(5, trip.getPrice());
            pstmt.setString(6, trip.getActivityType());
            pstmt.setInt(7, trip.getMaxParticipants());
            pstmt.setInt(8, trip.getAvailableSpots());
            pstmt.setDate(9, Date.valueOf(trip.getStartDate()));
            pstmt.setDate(10, Date.valueOf(trip.getEndDate()));
            pstmt.setString(11, trip.getImageUrl());
            pstmt.setInt(12, trip.getTripId());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    public boolean updateAvailableSpots(int tripId, int spotsToReduce) throws SQLException {
        String sql = "UPDATE trips SET available_spots = available_spots - ? WHERE trip_id = ? AND available_spots >= ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, spotsToReduce);
            pstmt.setInt(2, tripId);
            pstmt.setInt(3, spotsToReduce);
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    public List<String> getDistinctDestinations() throws SQLException {
        List<String> destinations = new ArrayList<>();
        String sql = "SELECT DISTINCT destination FROM trips WHERE status = 'ACTIVE' ORDER BY destination";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                destinations.add(rs.getString("destination"));
            }
        }
        return destinations;
    }
    
    public List<String> getDistinctActivityTypes() throws SQLException {
        List<String> activityTypes = new ArrayList<>();
        String sql = "SELECT DISTINCT activity_type FROM trips WHERE status = 'ACTIVE' ORDER BY activity_type";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                activityTypes.add(rs.getString("activity_type"));
            }
        }
        return activityTypes;
    }
    
    private Trip mapResultSetToTrip(ResultSet rs) throws SQLException {
        Trip trip = new Trip();
        trip.setTripId(rs.getInt("trip_id"));
        trip.setTitle(rs.getString("title"));
        trip.setDescription(rs.getString("description"));
        trip.setDestination(rs.getString("destination"));
        trip.setDuration(rs.getInt("duration"));
        trip.setPrice(rs.getBigDecimal("price"));
        trip.setActivityType(rs.getString("activity_type"));
        trip.setMaxParticipants(rs.getInt("max_participants"));
        trip.setAvailableSpots(rs.getInt("available_spots"));
        
        Date startDate = rs.getDate("start_date");
        if (startDate != null) {
            trip.setStartDate(startDate.toLocalDate());
        }
        
        Date endDate = rs.getDate("end_date");
        if (endDate != null) {
            trip.setEndDate(endDate.toLocalDate());
        }
        
        trip.setImageUrl(rs.getString("image_url"));
        trip.setStatus(rs.getString("status"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            trip.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            trip.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return trip;
    }
    public boolean restoreAvailableSpots(int tripId, int spotsToRestore) throws SQLException {
    String sql = "UPDATE trips SET available_spots = available_spots + ? WHERE trip_id = ?";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        
        pstmt.setInt(1, spotsToRestore);
        pstmt.setInt(2, tripId);
        
        return pstmt.executeUpdate() > 0;
    }
    }
}