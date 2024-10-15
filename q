// Email Inbound Action Script in ServiceNow with Enhanced Error Handling and Date Calculation

// Define the target table and fields
var targetTable = 'u_custom_table'; // Replace with your table's actual name
var targetField = 'u_total_text_messages'; // Replace with your target field name
var dateField = 'u_start_date'; // Replace with the field name for the start date

try {
    // Extract the email body from the inbound email
    var emailBody = email.body_text;

    // Regular expression to find the number after 'total number of text messages:'
    var regex = /total number of text messages:\s*(\d+)\s*\./i;
    var matches = emailBody.match(regex);

    // Validate and parse the text message count
    if (!matches || !matches[1]) {
        throw new Error('Failed to find "total number of text messages:" with a valid number in the email body.');
    }
    var textMessageCount = parseInt(matches[1], 10);
    if (isNaN(textMessageCount)) {
        throw new Error('Extracted text message count is not a valid number.');
    }
    gs.info('Total number of text messages: ' + textMessageCount);

    // Calculate the start date for the previous Wednesday
    var startDate = new GlideDateTime();
    startDate.addDaysLocalTime(-((startDate.getDayOfWeekLocalTime() + 2) % 7 + 2)); // Adjust days based on current day
    startDate.setDisplayValue(startDate.getLocalDate() + ' 00:00:00'); // Set to 00:00:00 on Wednesday
    gs.info('Calculated start date (previous Wednesday): ' + startDate.getDisplayValue());

    // Query and update the record in the target table
    var record = new GlideRecord(targetTable);
    record.addQuery('some_field', email.subject); // Modify this query to match your requirements
    record.query();

    if (record.next()) {
        // Update existing record
        record.setValue(targetField, textMessageCount);
        record.setValue(dateField, startDate);
        record.update();
        gs.info('Record updated successfully with text message count and start date.');
    } else {
        // Optionally create a new record if none is found
        record.initialize();
        record.setValue(targetField, textMessageCount);
        record.setValue(dateField, startDate);
        record.insert();
        gs.info('New record created successfully with text message count and start date.');
    }
} catch (error) {
    // Handle errors and log them
    gs.error('Error in Email Inbound Action: ' + error.message);
}
