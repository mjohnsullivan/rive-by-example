# Callback Controller
This example has a simple callback controller that calls a callback function when the animation completes. This works for one shot animations.

Animation controllers should inherit from `RiveAnimationController`. In the case of our custom controller (`CallbackAnimation`), we can re-use some of `SimpleAnimation's` set-up, so we inherit from that.

The math for calculating what frame the animation is currently in depends on data in the controller's `LinearAnimationInstance`, and is adapted from code found in its `advance()` function.
