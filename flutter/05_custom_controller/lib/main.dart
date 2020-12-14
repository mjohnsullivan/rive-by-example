import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() => runApp(MyApp());

/// A simple [RiveAnimationController] the can be started and paused; when
/// paused the animation continues to play until it reaches the end of its
/// animation loop.
class CompletingAnimation extends SimpleAnimation {
  CompletingAnimation(String animationName, {double mix})
      : super(animationName, mix: mix);

  /// Tracks whether the animation should enter a paused state at the end of the
  /// current animation cycle
  bool _pause = false;
  bool get pause => _pause;
  set pause(bool value) {
    _pause = value;
    // Start immediately if unpaused
    if (!value) {
      isActive = true;
    }
  }

  /// Pauses at the end of an animation loop if _pause is true
  void _pauseAtEndOfAnimation() {
    // Calculate the start time of the animation, which may not be 0 if work
    // area is enabled
    final start =
        instance.animation.enableWorkArea ? instance.animation.workStart : 0;
    // Calculate the frame the animation is currently on
    final currentFrame = ((instance.time - start) * instance.animation.fps);
    // If the animation is within the window of a single frame, pause
    if (currentFrame <= 1) {
      isActive = false;
    }
  }

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    // Apply the animation to the artboard with the appropriate level of mix
    instance.animation.apply(instance.time, coreContext: artboard, mix: mix);

    // If pause has been requested, try to pause
    if (_pause) {
      _pauseAtEndOfAnimation();
    }

    // If false, the animation has ended (it doesn't loop)
    if (!instance.advance(elapsedSeconds)) {
      isActive = false;
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mixing Animations',
      home: Scaffold(
        body: Center(
          child: MyAnimation(),
        ),
      ),
    );
  }
}

class MyAnimation extends StatefulWidget {
  @override
  _MyAnimationState createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation> {
  Artboard _artboard;
  CompletingAnimation _wipersAnimation;

  // Is the bounce animation paused
  var _isPaused = false;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  /// Loads dat afrom a Rive file and initializes playback
  _loadRiveFile() async {
    // Load your Rive data
    final data = await rootBundle.load('assets/off_road_car_0_6.riv');
    // Create a RiveFile from the binary data
    final file = RiveFile();
    if (file.import(data)) {
      // Get the artboard containing the animation you want to play
      final artboard = file.mainArtboard;
      // Idle plays continuously so we can use a SimpleAnimation
      artboard.addController(SimpleAnimation('idle'));
      // Bouncing can be paused and we want it to play to the end of the bounce
      // animation when complete, so let's use our custom controller
      artboard.addController(
        _wipersAnimation = CompletingAnimation('windshield_wipers'),
      );

      // Wrapped in setState so the widget knows the artboard is ready to play
      setState(() => _artboard = artboard);
    }
  }

  /// Sets the level of bounciness
  void _pause() =>
      setState(() => _wipersAnimation.pause = _isPaused = !_isPaused);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 3,
          child: _artboard != null ? Rive(artboard: _artboard) : Container(),
        ),
        Flexible(
          flex: 1,
          child: RaisedButton(
            child: Text(_isPaused ? 'Play' : 'Pause'),
            onPressed: _pause,
          ),
        ),
      ],
    );
  }
}
