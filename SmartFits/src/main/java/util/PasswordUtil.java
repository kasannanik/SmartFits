package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    // cost factor (work factor)
    private static final int WORKLOAD = 12;

    // Hash a password
    public static String hashPassword(String plain) {
        if (plain == null) return null;
        return BCrypt.hashpw(plain, BCrypt.gensalt(WORKLOAD));
    }

    // Verify a password against a stored hash
    public static boolean checkPassword(String plain, String hashed) {
        if (plain == null || hashed == null) return false;
        try {
            return BCrypt.checkpw(plain, hashed);
        } catch (Exception e) {
            return false;
        }
    }
}
