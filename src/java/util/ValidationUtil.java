// File: src/java/com/tripagency/util/ValidationUtil.java
package util;

import java.util.regex.Pattern;

public class ValidationUtil {
    private static final String EMAIL_REGEX = 
        "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    
    private static final Pattern EMAIL_PATTERN = Pattern.compile(EMAIL_REGEX);
    
    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }
    
    public static boolean isValidPhoneNumber(String phone) {
        if (phone == null || phone.trim().isEmpty()) return false;
        
        // Remove spaces, dashes, and parentheses
        String cleanPhone = phone.replaceAll("[\\s\\-\\(\\)]", "");
        
        // Check if it contains only digits and is 10-15 characters long
        return cleanPhone.matches("\\d{10,15}");
    }
    
    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }
}