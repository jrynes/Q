// Server Script
(function() {
    // Create a GlideRecord object to query the chatbot metrics table
    var gr = new GlideRecord('u_chatbot_metrics'); // Replace with your table name
    gr.query();

    // Initialize an array to hold the data
    var metricsData = [];
    while (gr.next()) {
        metricsData.push({
            date: gr.getValue('u_date'), // Replace with your actual field name
            messages: parseInt(gr.getValue('u_total_interactions'), 10) // Replace with your actual field name
        });
    }

    // Make the data available to the client script
    data.metricsData = metricsData;
})();
