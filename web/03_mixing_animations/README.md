# Play a Looping Animation

Following on from the previous example, let's look at how to continuously play a looping animation. We'll continue to use our truck example; the code to load the file is unchanged, but instead of showing the first frame, we'll create a render loop to play the ```idle``` animation.

We're going to replace the code to render the frame with a function that will render a frame at a given time interval, and call this function on every refresh cycle, using ```requestAnimationFrame```. This is the recommended way for creating animations in browsers (see [this](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial/Basic_animations) and [this](https://developer.mozilla.org/en-US/docs/Games/Anatomy)).

To calculate what frame to show, we simply take the previous frame's timestamp, compare it to the current, giving us the elapsed seconds:

```javascript
const elapsedTime = (time - lastTime) / 1000;
lastTime = time;
```

We then advance the animation by this elapsed time:

```javascript
myAnimInstance.advance(elapsedTime);
```

The animation itself is driven the artboard, so why advance both? The reason is that multiple animations can be applied to an artboard simultaneously, and Rive will mix these animation states together to produce some pretty sophisticated behavior. You'll see an example of this a little later,but for now, we advance the animation, apply it to the artboard, and then advance the artboard.

```javascript
myAnimInstance.advance(elapsedTime);
myAnimInstance.apply(artboard, 1.0);
artboard.advance(elapsedTime);
```

We then draw the frame in much the same way as we drew the single frame in the previous example, remembering to clear the canvas first:

```javascript
ctx.clearRect(0, 0, canvas.width, canvas.height);
ctx.save();
renderer.align(rive.Fit.contain, rive.Alignment.center, {
    minX: 0,
    minY: 0,
    maxX: canvas.width,
    maxY: canvas.height
}, artboard.bounds);
artboard.draw(renderer);
ctx.restore();
```

We call ```requestAnimationFrame``` inside the ```draw``` function to trigger another draw loop at the browser's current refresh rate. And we need to call it once ```draw``` is defined to start the first animation loop.