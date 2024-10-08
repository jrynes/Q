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

________________________________________________________________________________________________


api.controller = function() {
    var c = this;

    // Access data provided by the server script
    const data = c.data.metricsData;

    // Initialize the chart with the D3.js code here
    updateChart(data);

    function updateChart(data) {
        // Your D3.js chart code to render data on the page
    }
};


