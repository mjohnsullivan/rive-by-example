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
        
        // Get an animation and instance it
        const myAnim = artboard.animation('idle');
        const myAnimInstance = new rive.LinearAnimationInstance(myAnim);

        // Get the canvas where you want to render the animation and create a renderer
        const canvas = document.getElementById('riveCanvas');
        const ctx = canvas.getContext('2d');
        const renderer = new rive.CanvasRenderer(ctx);

        // Choose how you want the animation to align in the canvas
        ctx.save();
        renderer.align(rive.Fit.contain, rive.Alignment.center, {
            minX: 0,
            minY: 0,
            maxX: canvas.width,
            maxY: canvas.height
        }, artboard.bounds);

        // Advance to the first frame and draw the artboard
        artboard.advance(0);
        artboard.draw(renderer);
        ctx.restore();
    });
});