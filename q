document.getElementById('myButton').addEventListener('click', function() {
    // Send a custom event to Google Analytics
    gtag('event', 'button_click', {
        'event_category': 'user_interaction',
        'event_label': 'My Button',
        'value': 1
    });
});
