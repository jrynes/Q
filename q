document.querySelector('#sendMessageButton').addEventListener('click', function() {
  const messageContent = document.querySelector('#chatInput').value;
  gtag('event', 'Message Sent', {
    'event_category': 'Chatbot',
    'event_label': messageContent
  });
});
