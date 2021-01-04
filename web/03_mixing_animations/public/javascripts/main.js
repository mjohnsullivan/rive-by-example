Rive({
    // Loads the Wasm file
    locateFile: (file) => 'https://unpkg.com/rive-canvas@0.6.7/' + file,
}).then((rive) => {
    // Fetches the animation
    const req = new Request('/animations/off_road_car_0_6.riv');
    fetch(req).then((res) => {
        return res.arrayBuffer();
    }).then((buf) => {
        // The raw bytes of the animation are in the buffer, load them into a
        // Rive file
        const file = rive.load(new Uint8Array(buf));

        // Now get the artboard that contains the animations you want to play.
        // You animate the artboard, using the animations it contains.
        const artboard = file.defaultArtboard();

        // Get the animations and instance them
        const idleAnimInstance = new rive.LinearAnimationInstance(
            artboard.animation('idle')
        );
        const wipersAnimInstance = new rive.LinearAnimationInstance(
            artboard.animation('windshield_wipers')
        );

        // Get the canvas where you want to render the animation and create a renderer
        const canvas = document.getElementById('riveCanvas');
        const ctx = canvas.getContext('2d');
        const renderer = new rive.CanvasRenderer(ctx);

        // Track the last time the loop was performed
        let lastTime = 0;

        // This is the looping function where the animation frames will be
        // rendered at the correct time interval
        function draw(time) {
            // On the first pass, make sure lastTime has a valid value
            if (!lastTime) {
                lastTime = time;
            }
            // Calculate the elapsed time between frames in seconds
            const elapsedTime = (time - lastTime) / 1000;
            lastTime = time;

            // Advance the animations by the elapsed number of seconds
            idleAnimInstance.advance(elapsedTime);
            wipersAnimInstance.advance(elapsedTime);
            // Apply the animations to the artboard. The animations will be
            // mixed together when the artboard is advanced. The strength of the
            // mix is determined by the second parameter, a value between 0 and
            // 1. Here, both animations are being equally mixed.
            idleAnimInstance.apply(artboard, 1.0);
            wipersAnimInstance.apply(artboard, 1.0);
            // Once the animations have been applied to the artboard, advance it
            // by the elapsed time.
            artboard.advance(elapsedTime);

            // Clear the current frame of the canvas
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            // Render the frame in the canvas
            ctx.save();
            renderer.align(rive.Fit.contain, rive.Alignment.center, {
                minX: 0,
                minY: 0,
                maxX: canvas.width,
                maxY: canvas.height
            }, artboard.bounds);
            artboard.draw(renderer);
            ctx.restore();

            // Calling requestAnimationFrame will call the draw function again
            // at the correct refresh rate. See
            // https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial/Basic_animations
            // for more details.
            requestAnimationFrame(draw);
        }

        // Start animating by calling draw on the next refresh cycle.
        requestAnimationFrame(draw);
    });
});