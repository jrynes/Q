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

________________________________________________________________________________________________

api.controller = function() {
    var c = this;

    // Access data provided by the server script
    var data = c.data.metricsData;

    // Initialize the chart with the D3.js code here
    updateChart(data);

    function updateChart(filteredData) {
        var margin = { top: 40, right: 30, bottom: 60, left: 60 },
            width = 800 - margin.left - margin.right,
            height = 400 - margin.top - margin.bottom;

        var svg = d3.select(".chart")
            .append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

        var x = d3.scaleBand()
            .range([0, width])
            .padding(0.2);

        var y = d3.scaleLinear()
            .range([height, 0]);

        var xAxis = svg.append("g")
            .attr("transform", "translate(0," + height + ")");

        var yAxis = svg.append("g");

        function make_y_gridlines() {
            return d3.axisLeft(y)
                .ticks(5);
        }

        // Add x and y axis labels
        svg.append("text")
            .attr("class", "axis-label")
            .attr("x", width / 2)
            .attr("y", height + 40)
            .style("text-anchor", "middle")
            .text("Date");

        svg.append("text")
            .attr("class", "axis-label")
            .attr("x", -height / 2)
            .attr("y", -40)
            .attr("transform", "rotate(-90)")
            .style("text-anchor", "middle")
            .text("Messages");

        var tooltip = d3.select("#tooltip");

        var gradient = svg.append("defs")
            .append("linearGradient")
            .attr("id", "bar-gradient")
            .attr("gradientTransform", "rotate(90)");
        gradient.append("stop").attr("offset", "0%").attr("stop-color", "var(--primary-color)");
        gradient.append("stop").attr("offset", "100%").attr("stop-color", "var(--secondary-color)");

        x.domain(filteredData.map(function(d) { return d.date; }));
        y.domain([0, d3.max(filteredData, function(d) { return d.messages; })]);

        var movingAvg = calculateMovingAverage(filteredData.map(function(d) { return d.messages; }), 3);

        svg.append("g")
            .attr("class", "grid")
            .call(make_y_gridlines()
                .tickSize(-width)
                .tickFormat("")
            );

        var bars = svg.selectAll(".bar")
            .data(filteredData, function(d) { return d.date; });

        bars.exit()
            .transition()
            .duration(750)
            .attr("y", height)
            .attr("height", 0)
            .remove();

        var enterBars = bars.enter()
            .append("rect")
            .attr("class", "bar")
            .attr("x", function(d) { return x(d.date); })
            .attr("y", height)
            .attr("width", x.bandwidth())
            .attr("height", 0)
            .attr("fill", "url(#bar-gradient)");

        enterBars.merge(bars)
            .on("mouseover", function(event, d) {
                tooltip.style("visibility", "visible")
                    .text(d.date + ": " + d.messages + " messages")
                    .style("left", (event.pageX + 10) + "px")
                    .style("top", (event.pageY - 20) + "px");
                d3.select(this).attr("fill", "var(--hover-color)");
            })
            .on("mousemove", function(event) {
                tooltip.style("left", (event.pageX + 10) + "px")
                       .style("top", (event.pageY - 20) + "px");
            })
            .on("mouseout", function() {
                tooltip.style("visibility", "hidden");
                d3.select(this).attr("fill", "url(#bar-gradient)");
            })
            .transition()
            .duration(750)
            .attr("x", function(d) { return x(d.date); })
            .attr("y", function(d) { return y(d.messages); })
            .attr("width", x.bandwidth())
            .attr("height", function(d) { return height - y(d.messages); });

        xAxis.transition().duration(750).call(d3.axisBottom(x));
        yAxis.transition().duration(750).call(d3.axisLeft(y));

        var line = d3.line()
            .x(function(d, i) { return i === 0 ? 0 : (i === movingAvg.length - 1 ? width : x(filteredData[i].date) + x.bandwidth() / 2); })
            .y(function(d) { return y(d); })
            .curve(d3.curveMonotoneX);

        svg.append("path")
            .datum(movingAvg)
            .attr("class", "trend-line")
            .attr("fill", "none")
            .attr("stroke", "var(--trend-line-color)")
            .attr("stroke-width", 2)
            .attr("d", line);
    }

    function calculateMovingAverage(data, windowSize) {
        var avgData = [];
        for (var i = 0; i < data.length; i++) {
            var windowData = data.slice(Math.max(0, i - windowSize + 1), i + 1);
            var average = d3.mean(windowData);
            avgData.push(average);
        }
        return avgData;
    }

    function filterData(startDate, endDate) {
        return data.filter(function(d) {
            var date = new Date(d.date);
            return date >= startDate && date <= endDate;
        });
    }

    document.getElementById('filter').addEventListener('click', function() {
        var startDate = new Date(document.getElementById('start-date').value);
        var endDate = new Date(document.getElementById('end-date').value);
        var filteredData = filterData(startDate, endDate);
        updateChart(filteredData);
    });
};



_____________________________________________________________________________________________

<h1>Chatbot Usage Over Time</h1>
<div id="controls">
    <label for="start-date">Start Date:</label>
    <input type="date" id="start-date" value="2024-01-01">
    <label for="end-date">End Date:</label>
    <input type="date" id="end-date" value="2024-12-31">
    <button id="filter">Apply Filter</button>
    <button id="exportCsv">Export to CSV</button>
    <button id="downloadChart">Download Chart</button>
</div>
<div class="chart"></div>
<div class="tooltip" id="tooltip"></div>
<div id="legend">
    <span id="legend-line"></span><span>Moving Average Trend</span>
</div>

_____________________________________________________________________________________________

<script src="https://d3js.org/d3.v6.min.js"></script>






