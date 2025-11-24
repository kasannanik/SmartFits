package util;

import javax.servlet.http.HttpServletRequest;

/**
 * Put messages into request so JSP can show alerts.
 * Keeps servlet code tidy.
 */
public class AlertUtil {

    public static void setError(HttpServletRequest req, String message) {
        req.setAttribute("errorMessage", message);
    }

    public static void setSuccess(HttpServletRequest req, String message) {
        req.setAttribute("successMessage", message);
    }
}
