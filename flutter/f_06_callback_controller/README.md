# Callback Controller
This example has a callback controller that calls a function when an animation completes, ideal for knowing when a one-shot finishes.

The controller also has a ```resetAndStart()``` function that resets the animation to its starting state and replays it.

Animation controllers should inherit from `RiveAnimationController`. In the case of our custom controller (```CallbackAnimation```), we can re-use some of ```SimpleAnimation```'s set-up, so we inherit from that.

The math for calculating what frame the animation is currently in depends on data in the controller's ```LinearAnimationInstance````, and is adapted from code found in ```advance()```.
