package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class Booking {
    private int bookingId;
    private int tripId;
    private int userId; // NEW: Link to user who made the booking
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    private int participants;
    private BigDecimal totalAmount;
    private LocalDate bookingDate;
    private String status;
    private LocalDateTime createdAt;
    private List<Traveller> travellers;
    
    // Additional fields for display
    private String tripTitle; // For displaying trip info with booking
    private String tripDestination;

    // Constructors
    public Booking() {}

    public Booking(int tripId, int userId, String customerName, String customerEmail, 
                   String customerPhone, int participants, BigDecimal totalAmount, 
                   LocalDate bookingDate) {
        this.tripId = tripId;
        this.userId = userId;
        this.customerName = customerName;
        this.customerEmail = customerEmail;
        this.customerPhone = customerPhone;
        this.participants = participants;
        this.totalAmount = totalAmount;
        this.bookingDate = bookingDate;
        this.status = "PENDING";
    }

    // Getters and Setters
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getTripId() { return tripId; }
    public void setTripId(int tripId) { this.tripId = tripId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }

    public int getParticipants() { return participants; }
    public void setParticipants(int participants) { this.participants = participants; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public LocalDate getBookingDate() { return bookingDate; }
    public void setBookingDate(LocalDate bookingDate) { this.bookingDate = bookingDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public List<Traveller> getTravellers() { return travellers; }
    public void setTravellers(List<Traveller> travellers) { this.travellers = travellers; }

    public String getTripTitle() { return tripTitle; }
    public void setTripTitle(String tripTitle) { this.tripTitle = tripTitle; }

    public String getTripDestination() { return tripDestination; }
    public void setTripDestination(String tripDestination) { this.tripDestination = tripDestination; }
}