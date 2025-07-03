package util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DateUtil {
    
    public static String formatLocalDateTime(LocalDateTime dateTime) {
        if (dateTime == null) return "";
        return dateTime.format(DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
    }
    
    public static String formatLocalDate(LocalDate date) {
        if (date == null) return "";
        return date.format(DateTimeFormatter.ofPattern("MMM dd, yyyy"));
    }
    
    public static String formatLocalDateShort(LocalDate date) {
        if (date == null) return "";
        return date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }
    
    public static String formatLocalDateTimeShort(LocalDateTime dateTime) {
        if (dateTime == null) return "";
        return dateTime.format(DateTimeFormatter.ofPattern("MMM dd, yyyy"));
    }
}