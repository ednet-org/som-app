document.addEventListener('DOMContentLoaded', function() {
    var canvas = document.getElementById('myCanvas');
    canvas.width = 3840;  // Set canvas width for 4K resolution
    canvas.height = 2160; // Set canvas height for 4K resolution
    var ctx = canvas.getContext('2d');

    // Define the boxes
    var scaleFactor = 2; // Scale factor for larger display
    var components = [
        {x: 100, y: 200, width: 400, height: 200, label: "Core Repository", desc: "Centralized data access and logic, interfaces with models to manage data retrieval and updates."},
        {x: 600, y: 200, width: 400, height: 200, label: "Entity Base", desc: "Defines base functionality and common attributes for all entities, ensuring consistent behavior and data structure."},
        {x: 1100, y: 200, width: 400, height: 200, label: "ID Management", desc: "Manages unique identifiers for all entities, critical for tracking and relational mapping."},
        {x: 600, y: 500, width: 400, height: 200, label: "Concept Code Gen", desc: "Automates the generation of model-specific code, enhancing consistency and reducing manual errors."},
        {x: 100, y: 800, width: 400, height: 200, label: "SOM Manager", desc: "Coordinates operations across service object models, managing lifecycle and state transitions."},
        {x: 600, y: 800, width: 400, height: 200, label: "Test Components", desc: "Ensures functionality and robustness of models through systematic testing of all components."}
    ];

    var itemBackground = 'lightblue';
    var black = 'black';
    var orange = 'orange';

    ctx.font = '32px Arial'; // Increase font size

    // Draw the components
    components.forEach(function(component) {
        ctx.fillStyle = itemBackground;
        ctx.fillRect(component.x, component.y, component.width, component.height);
        ctx.strokeRect(component.x, component.y, component.width, component.height);
        ctx.fillStyle = black;
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(component.label, component.x + component.width / 2, component.y + component.height / 2);
    });

    // Add event listener for tooltip
    canvas.addEventListener('mousemove', function(event) {
        var x = event.clientX - canvas.offsetLeft;
        var y = event.clientY - canvas.offsetTop;
        var hover = false;

        ctx.clearRect(0, 0, canvas.width, canvas.height); // Clear the canvas

        components.forEach(function(component) {
            ctx.fillStyle = itemBackground;
            ctx.fillRect(component.x, component.y, component.width, component.height);
            ctx.strokeRect(component.x, component.y, component.width, component.height);
            ctx.fillStyle = black;
            ctx.fillText(component.label, component.x + component.width / 2, component.y + component.height / 2);

            // Check if we are hovering over a component
            if (y > component.y && y < component.y + component.height && x > component.x && x < component.x + component.width) {
                ctx.fillStyle = orange;
                ctx.fillRect(component.x, component.y, component.width, component.height);
                ctx.fillStyle = black;
                ctx.font = '48px Arial'; // Decrease font size
                ctx.fillStyle = orange;
                ctx.fillText(component.desc, 1500, 1200); // Display the description at the bottom of the canvas, centralized
                ctx.fillStyle = black;
                ctx.font = '32px Arial'; // Increase font size
                ctx.fillText(component.label, component.x + component.width / 2, component.y + component.height / 2);
                hover = true;
            }
        });

        if (!hover) {
            components.forEach(function(component) {
                ctx.fillStyle = itemBackground;
                ctx.fillRect(component.x, component.y, component.width, component.height);
                ctx.strokeRect(component.x, component.y, component.width, component.height);
                ctx.fillStyle = black;
                ctx.fillText(component.label, component.x + component.width / 2, component.y + component.height / 2);
            });
        }
    });
});
