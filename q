import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CookieExampleServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set a cookie with a 3-hour expiration
        setCookie(response, "id_token", "your_id_token_value", 3);
        setCookie(response, "session_id", "your_session_value", 3);

        response.getWriter().println("Cookies set successfully.");
    }

    private void setCookie(HttpServletResponse response, String name, String value, int hours) {
        Cookie cookie = new Cookie(name, value);
        cookie.setMaxAge(hours * 3600); // Set the expiration time in seconds
        cookie.setPath("/"); // Set the path for the cookie
        cookie.setHttpOnly(true); // Make it HttpOnly
        cookie.setSecure(true); // Set to true if using HTTPS

        response.addCookie(cookie); // Add the cookie to the response
    }
}



protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // Retrieve the cookie
    String idToken = getCookieValue(request, "id_token");
    String sessionId = getCookieValue(request, "session_id");

    response.getWriter().println("ID Token: " + idToken);
    response.getWriter().println("Session ID: " + sessionId);
}

private String getCookieValue(HttpServletRequest request, String name) {
    Cookie[] cookies = request.getCookies(); // Get all cookies
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals(name)) {
                return cookie.getValue(); // Return the value of the cookie
            }
        }
    }
    return null; // Return null if the cookie doesn't exist
}



