# Mixing Animations

Now that we know how to play an animation, let's look at mixing a couple of looping animations together.

In order to mix different animations, they must all belong to the same artboard. We first instance the animations, and then individually advance and apply them to the artboard. Then, when the artboard is advanced, it will mix the animations together.

 The code is almost identical to handling a single animation. Our artboard has two animations, ```idle``` and ```windshield_wipers```. We instance both of these:

 ```javascript
const idleAnimInstance = new rive.LinearAnimationInstance(
    artboard.animation('idle')
);
const wipersAnimInstance = new rive.LinearAnimationInstance(
    artboard.animation('windshield_wipers')
);
 ```

 We can then advance them by whatever amount of time we choose:

 ```javascript
idleAnimInstance.advance(elapsedTime);
wipersAnimInstance.advance(elapsedTime);
 ```

 Note that while the times in this case are the same, we could easily advance each animation by a different time interval, or even in different directions.

 We apply the animations to the artboard:

 ```javascript
idleAnimInstance.apply(artboard, 1.0);
wipersAnimInstance.apply(artboard, 1.0);
 ```

The second parameter in ```apply``` is the mix value, between 0 and 1. It determines the strength/weight/influence of each animation in the overall mix. When the animations affect the same items on the artboard, these values will determine which animations have more effect in the final mix.

Finally, we advance the artboard, which will mix the animations together:

```javascript
artboard.advance(elapsedTime);
```