
pom.xml
_______________________

<dependency>
    <groupId>com.okta.jwt</groupId>
    <artifactId>okta-jwt-verifier</artifactId>
    <version>0.5.0</version> <!-- Check for the latest version -->
</dependency>
  
<dependency>
    <groupId>com.okta.jwt</groupId>
    <artifactId>okta-jwt-verifier-impl</artifactId>
    <version>0.5.0</version> <!-- Check for the latest version -->
    <scope>runtime</scope>
</dependency>

_______________________

import com.okta.jwt.Jwt;
import com.okta.jwt.AccessTokenVerifier;
import com.okta.jwt.JwtVerifiers;
import javax.servlet.http.HttpServletRequest;
import javax.net.ssl.SSLContext;
import java.time.Duration;

public class JwtValidator {

    private static AccessTokenVerifier jwtVerifier;

    static {
        try {
            // Build the JWT Verifier (You may want to externalize the issuer/audience)
            jwtVerifier = JwtVerifiers.accessTokenVerifierBuilder()
                .setIssuer("https://{yourOktaDomain}/oauth2/default") // Okta issuer URL
                .setAudience("api://default")                         // Audience
                .setConnectionTimeout(Duration.ofSeconds(1))          // Timeout options
                .setRetryMaxAttempts(2)                               // Retry attempts
                .setRetryMaxElapsed(Duration.ofSeconds(10))           // Retry duration
                .build();
        } catch (Exception e) {
            throw new RuntimeException("Error initializing JwtVerifier: " + e.getMessage());
        }
    }

    // Method to validate JWT
    public static boolean validateToken(HttpServletRequest request) {
        try {
            // Get the token from the authorization header (commonly used for bearer tokens)
            String authHeader = request.getHeader("Authorization");

            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                String token = authHeader.substring(7); // Extract the token

                // Validate the token (throws exception if invalid)
                Jwt jwt = jwtVerifier.decode(token);

                // Token is valid, you can also fetch claims if needed
                System.out.println("JWT Claims: " + jwt.getClaims());
                return true;
            } else {
                System.out.println("No JWT token found in the request");
                return false;
            }
        } catch (Exception e) {
            System.out.println("Invalid JWT token: " + e.getMessage());
            return false;
        }
    }
}

_______________________



import javax.servlet.http.HttpServletRequest;
import org.apache.struts2.interceptor.ServletRequestAware; // Assuming Struts framework
import com.opensymphony.xwork2.ActionSupport;

public class HomePageAction extends ActionSupport implements ServletRequestAware {

    private HttpServletRequest request;

    @Override
    public String execute() {
        // Check JWT authentication
        boolean isAuthenticated = JwtValidator.validateToken(request);

        if (isAuthenticated) {
            // Proceed to the homepage if valid
            return SUCCESS;
        } else {
            // If not authenticated, redirect to the login page
            return LOGIN; // You can define what LOGIN means in your struts.xml
        }
    }

    @Override
    public void setServletRequest(HttpServletRequest request) {
        this.request = request;
    }
}

