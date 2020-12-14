# Custom Controller

This example has a simple custom animation controller that can pause an animation once the end of its current loop is reached. This works for both looping and ping-pong animations.

Animation controllers should inherit from ```RiveAnimationController```. In the case of our custom controller (```CompletingAnimation```), we can re-use some of ```SimpleAnimation's``` set-up, so we inherit from that.

The math for calculating what frame the animation is currently in depends on data in the controller's ```LinearAnimationInstance```, and is adapted from code found in its ```advance()``` function.