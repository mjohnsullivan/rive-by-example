/// Example kindly provided by https://github.com/dancamdev

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() => runApp(MyApp());

/// A simple [RiveAnimationController] that runs a callback when the animation
/// has finished;
class CallbackAnimation extends SimpleAnimation {
  CallbackAnimation(
    String animationName, {
    @required this.callback,
    double mix,
  }) : super(animationName, mix: mix);

  final Function callback;

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    // Apply the animation to the artboard with the appropriate level of mix
    instance.animation.apply(instance.time, coreContext: artboard, mix: mix);

    // If false, the animation has ended (it doesn't loop)
    if (!instance.advance(elapsedSeconds)) {
      _onCompleted(callback);
    }
  }

  void _onCompleted(Function callback) {
    final start =
        instance.animation.enableWorkArea ? instance.animation.workStart : 0;
    final currentFrame = ((instance.time - start) * instance.animation.fps);
    final endFrame =
        instance.animation.enableWorkArea ? instance.animation.workEnd : 120;

    // if the animation is within one frame to the end I'll call the callback
    if (currentFrame >= endFrame - 1) {
      isActive = false;

      // addPostFrameCallback added to avoid build collision
      WidgetsBinding.instance.addPostFrameCallback((_) => callback());
    }
  }

  /// Resets the animation to its starting state and starts it
  void resetAndStart(RuntimeArtboard artboard) {
    // TODO: Move reset logic into linear animation instance
    instance.time =
        (instance.animation.enableWorkArea ? instance.animation.workStart : 0)
                .toDouble() /
            instance.animation.fps;
    isActive = true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Callback Animation',
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
  CallbackAnimation _animation;

  // Has the animation finished
  bool _isAnimationComplete = false;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  /// Loads dat afrom a Rive file and initializes playback
  _loadRiveFile() async {
    // Load your Rive data
    final data = await rootBundle.load('assets/success_check.riv');
    // Create a RiveFile from the binary data
    final file = RiveFile();
    if (file.import(data)) {
      // Get the artboard containing the animation you want to play
      final artboard = file.mainArtboard;

      artboard.addController(
        _animation = CallbackAnimation(
          'Untitled',
          callback: () => setState(() => _isAnimationComplete = true),
        ),
      );

      // Wrapped in setState so the widget knows the artboard is ready to play
      setState(() => _artboard = artboard);
    }
  }

  void _replay() {
    _animation.resetAndStart(_artboard);
    setState(() => _isAnimationComplete = false);
  }

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
            child: Text(_isAnimationComplete ? 'Replay' : 'Running'),
            color: Colors.green,
            onPressed: _isAnimationComplete ? _replay : null,
          ),
        ),
      ],
    );
  }
}
