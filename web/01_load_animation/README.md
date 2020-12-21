# Load a Rive File

This example demonstrates how to load a Rive file and display a single frame of animation.

Rive's web runtime can be found [here](https://www.npmjs.com/package/rive-canvas), and is available on this [CDN](https://unpkg.com/rive-canvas@0.6.7/rive.js). The web runtime comprises two components: the JS runtime which provides the API with which to instantiate and control animations, and a Wasm engine that drives animations.

The Wasm code must first be loaded. In this example we fetch the Wasm over the network and then instantiate it:

```javascript
Rive({
    // Loads the Wasm file
    locateFile: (file) => 'https://unpkg.com/rive-canvas@0.6.7/' + file,
        }).then((rive) => {
    // ...
    });
});
```

At this stage, Rive's runtime is ready to go.

Next we load a Rive file over the network and instantiate it:

```javascript
// Fetches the animation
const req = new Request('/animations/off_road_car_0_6.riv');
fetch(req).then((res) => {
    return res.arrayBuffer();
}).then((buf) => {
    // The raw bytes of the animation are in the buffer, load them into a
    // Rive file
    const file = rive.load(new Uint8Array(buf));
});
```


It's important to understand the structure of a Rive file, and how these pertain to animations. A Rive file contains artboards, and each artboard contains animations. Animations within an artboard can be mixed together.

In the Rive runtime, animations are managed by [RiveAnimationControllers](https://github.com/rive-app/rive-flutter/blob/master/lib/src/rive_core/rive_animation_controller.dart). The behavior of the animation can be defined by subclassing ```RiveAnimationController```. The [Rive Flutter runtime](https://pub.dev/packages/rive) provides a ```SimpleAnimation``` controller as an easy means to play a looping animation and as an example of how to write your own controller. However, it's recommended that you write your own controllers if you want to do more than just play an animation.

Controllers are attached to the artboard which contains the animations, and it's the artboard that you supply to the ```Rive()``` widget to place in your widget tree. Why not simply add animations to a widget? The reason for this is that Rive is designed to mix animations together, and multiple animations may be in play on a single artboard at any time.

This example continuously plays a looping animation, which is precisely what ```SimpleAnimation``` was designed to do.%