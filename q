import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.UUID;

public class PkceUtil {

    // Generate a random code verifier
    public static String generateCodeVerifier() {
        return UUID.randomUUID().toString().replace("-", "") + UUID.randomUUID().toString().replace("-", "");
    }

    // Generate the code challenge based on the code verifier (SHA-256 hash + Base64 URL-encoded)
    public static String generateCodeChallenge(String codeVerifier) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(codeVerifier.getBytes(StandardCharsets.US_ASCII));

        return Base64.getUrlEncoder().withoutPadding().encodeToString(hash);
    }
}


______________________________________________

// Assuming you have generated the code verifier and code challenge
String codeVerifier = PkceUtil.generateCodeVerifier();
String codeChallenge = PkceUtil.generateCodeChallenge(codeVerifier);

// Save the code verifier for later use when exchanging the authorization code
session.setAttribute("codeVerifier", codeVerifier);

// Authorization URL with PKCE parameters
String authorizationUrl = "https://{yourOktaDomain}/oauth2/default/v1/authorize"
        + "?client_id=YOUR_CLIENT_ID"
        + "&response_type=code"
        + "&scope=openid profile email"
        + "&redirect_uri=https://yourapp.com/callback"
        + "&state=" + UUID.randomUUID().toString()
        + "&code_challenge=" + codeChallenge
        + "&code_challenge_method=S256";

// Redirect the user to the authorization URL
response.sendRedirect(authorizationUrl);


___________________________________________

// Retrieve the code verifier from the session
String codeVerifier = (String) session.getAttribute("codeVerifier");

// Authorization code received from Okta's redirect after user logs in
String authorizationCode = request.getParameter("code");

// Exchange the authorization code for an access token and ID token
HttpURLConnection connection = (HttpURLConnection) new URL("https://{yourOktaDomain}/oauth2/default/v1/token").openConnection();
connection.setRequestMethod("POST");
connection.setDoOutput(true);
connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

// Build the POST body parameters
String postData = "grant_type=authorization_code"
        + "&code=" + authorizationCode
        + "&redirect_uri=https://yourapp.com/callback"
        + "&client_id=YOUR_CLIENT_ID"
        + "&code_verifier=" + codeVerifier;

// Send the POST request
try (DataOutputStream writer = new DataOutputStream(connection.getOutputStream())) {
    writer.writeBytes(postData);
    writer.flush();
}

// Get the response from Okta (access token, ID token, etc.)
int responseCode = connection.getResponseCode();
if (responseCode == HttpURLConnection.HTTP_OK) {
    // Handle successful token exchange
    try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
        String line;
        StringBuilder response = new StringBuilder();
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        System.out.println("Token response: " + response.toString());
    }
} else {
    // Handle error in token exchange
    System.out.println("Error during token exchange: " + connection.getResponseMessage());
}


__________________________________________________



    public static String ensureCodeVerifierInSession(HttpSession session) throws NoSuchAlgorithmException {
        // Check if the code_verifier already exists in the session
        String codeVerifier = (String) session.getAttribute("codeVerifier");

        if (codeVerifier == null || codeVerifier.isEmpty()) {
            // If code_verifier is not found, generate a new one
            codeVerifier = PkceUtil.generateCodeVerifier();

            // Store the newly generated code_verifier in the session
            session.setAttribute("codeVerifier", codeVerifier);
        }

        // Return the code_verifier (either retrieved or newly generated)
        return codeVerifier;
    }



