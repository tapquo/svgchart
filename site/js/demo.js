document.body.onload = function() {

    var SIMPLE_MOCK = {
        labels: ["January", "February", "March"],
        dataset: [
            {name: "Views", values: [-10, 15, 25]}
        ]
    };

    var MULTI_MOCK = {
        labels: ["January", "February", "March"],
        dataset: [
            {name: "Views", values: [-10, 15, 25]},
            {name: "Likes", values: [6, -8, 10]},
            {name: "Retweets", values: [-1, 8, 18]},
            {name: "Shares", values: [6, 12, 18]}
        ]
    };

    // column charts
    var columnChart = new Chart.Column(document.getElementById("column_simple"));
    columnChart.setData(SIMPLE_MOCK);
    columnChart.draw();
    var columnChart2 = new Chart.Column(document.getElementById("column_multi"));
    columnChart2.setData(MULTI_MOCK);
    columnChart2.draw();

    // row charts
    var rowChart = new Chart.Row(document.getElementById("row_simple"));
    rowChart.setData(SIMPLE_MOCK);
    rowChart.draw();
    var rowChart2 = new Chart.Row(document.getElementById("row_multi"));
    rowChart2.setData(MULTI_MOCK);
    rowChart2.draw();

    // points charts
    var pointChart = new Chart.Point(document.getElementById("point_simple"));
    pointChart.setData(SIMPLE_MOCK);
    pointChart.draw();
    var pointChart2 = new Chart.Point(document.getElementById("point_multi"));
    pointChart2.setData(MULTI_MOCK);
    pointChart2.draw();

    // line charts
    var lineChart = new Chart.Line(document.getElementById("line_simple"));
    lineChart.setData(SIMPLE_MOCK);
    lineChart.draw();
    var lineChart2 = new Chart.Line(document.getElementById("line_multi"));
    lineChart2.setData(MULTI_MOCK);
    lineChart2.draw();

    // area charts
    var areaChart = new Chart.Area(document.getElementById("area_simple"));
    areaChart.setData(SIMPLE_MOCK);
    areaChart.draw();
    var areaChart2 = new Chart.Area(document.getElementById("area_multi"));
    areaChart2.setData(MULTI_MOCK);
    areaChart2.draw();

    // pie chart
    var PIE_MOCK = [
        {name: "Likes",     value: 16},
        {name: "Views",     value: 8},
        {name: "Shares",    value: 12},
        {name: "Others 1",  value: 8},
        {name: "Others 2",  value: 18},
        {name: "Others 3",  value: 28},
        {name: "Others 4",  value: 61}
    ];

    var pieChart = new Chart.Pie(document.getElementById("pie_simple"));
    pieChart.setData(PIE_MOCK);
    pieChart.draw();

};