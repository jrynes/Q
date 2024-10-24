function setCookie(name, value, hours) {
    const expires = new Date(Date.now() + hours * 3600 * 1000).toUTCString(); // Calculate expiration date
    document.cookie = `${name}=${encodeURIComponent(value)}; expires=${expires}; path=/; Secure; HttpOnly`;
}

// Example usage:
setCookie('id_token', 'your_id_token_value', 3); // Expires in 3 hours


setCookie('session_id', 'your_session_value', 3);

function getCookie(name) {
    const value = `; ${document.cookie}`; // Prepend a semicolon to handle the case where the cookie is the first one
    const parts = value.split(`; ${name}=`); // Split the cookie string by the cookie name
    if (parts.length === 2) {
        return decodeURIComponent(parts.pop().split(';').shift()); // Decode and return the cookie value
    }
    return null; // Return null if the cookie doesn't exist
}

// Example usage:
const idToken = getCookie('id_token');
console.log(idToken); // Will log the value of 'id_token' if it exists




// Name of the cookie you want to retrieve
const cookieName = 'id_token';

// Get the cookie string
const cookieString = document.cookie;

// Check if the cookie exists
if (cookieString) {
    // Split the cookie string into individual cookies
    const cookiesArray = cookieString.split('; ');

    // Find the desired cookie
    const cookieValue = cookiesArray.find(cookie => cookie.startsWith(`${cookieName}=`));

    // If the cookie is found, extract its value
    if (cookieValue) {
        const value = cookieValue.split('=')[1]; // Get the value part after '='
        const decodedValue = decodeURIComponent(value); // Decode the cookie value
        console.log(decodedValue); // Outputs the cookie value
    } else {
        console.log(`${cookieName} not found`); // If the cookie does not exist
    }
} else {
    console.log('No cookies found');
}


