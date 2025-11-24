package util;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;

/**
 * Small helper validation functions used across servlets and DAOs.
 */
public class ValidationUtil {

    public static boolean isNotEmpty(String s) {
        return s != null && !s.trim().isEmpty();
    }

    public static boolean isValidUsername(String s) {
        if (!isNotEmpty(s)) return false;
        return s.length() >= 3 && s.length() <= 40 && s.matches("[A-Za-z0-9_.-]+");
    }

    public static boolean isValidEmail(String e) {
        if (e == null || e.trim().isEmpty()) return true; // optional email
        return e.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    }

    public static boolean isNonNegativeInteger(String s) {
        try {
            int v = Integer.parseInt(s);
            return v >= 0;
        } catch (Exception ex) {
            return false;
        }
    }

    public static boolean isValidDate(String s) {
        try {
            LocalDate.parse(s);
            return true;
        } catch (DateTimeParseException ex) {
            return false;
        }
    }
}
