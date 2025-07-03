// File: src/java/com/tripagency/model/Traveller.java
package model;

public class Traveller {
    private int travellerId;
    private int bookingId;
    private String name;
    private int age;
    private String gender;
    private String passportNumber;

    // Constructors
    public Traveller() {}

    public Traveller(int bookingId, String name, int age, String gender, String passportNumber) {
        this.bookingId = bookingId;
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.passportNumber = passportNumber;
    }

    // Getters and Setters
    public int getTravellerId() { return travellerId; }
    public void setTravellerId(int travellerId) { this.travellerId = travellerId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getPassportNumber() { return passportNumber; }
    public void setPassportNumber(String passportNumber) { this.passportNumber = passportNumber; }
}