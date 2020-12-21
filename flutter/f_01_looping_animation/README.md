# Simple Looping Animation

It's important to understand the structure of a Rive file, and how these pertain to animations. A Rive file contains artboards, and each artboard contains animations. Animations within an artboard can be mixed together.

In the Rive runtime, animations are managed by [RiveAnimationControllers](https://github.com/rive-app/rive-flutter/blob/master/lib/src/rive_core/rive_animation_controller.dart). The behavior of the animation can be defined by subclassing ```RiveAnimationController```. The [Rive Flutter runtime](https://pub.dev/packages/rive) provides a ```SimpleAnimation``` controller as an easy means to play a looping animation and as an example of how to write your own controller. However, it's recommended that you write your own controllers if you want to do more than just play an animation.

Controllers are attached to the artboard which contains the animations, and it's the artboard that you supply to the ```Rive()``` widget to place in your widget tree. Why not simply add animations to a widget? The reason for this is that Rive is designed to mix animations together, and multiple animations may be in play on a single artboard at any time.

This example continuously plays a looping animation, which is precisely what ```SimpleAnimation``` was designed to do.