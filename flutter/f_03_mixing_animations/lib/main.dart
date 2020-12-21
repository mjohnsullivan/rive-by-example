import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() => runApp(MyApp());

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
  /// The artboard we'll use to play an animation
  Artboard _artboard;
  SimpleAnimation _bounceAnimation, _wipersAnimation;

  // State of play of the bounce and wipe animations
  bool _bouncing = false;
  bool _wiping = false;

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
      // Create a SimpleAnimation controller for each animation
      artboard.addController(SimpleAnimation('idle'));
      artboard.addController(_bounceAnimation = SimpleAnimation('bouncing'));
      artboard.addController(
          _wipersAnimation = SimpleAnimation('windshield_wipers'));

      // We're going to play the idle animation continuously and mix in the
      // others when buttons are pressed.
      _bounceAnimation.isActive = _bouncing;
      _wipersAnimation.isActive = _wiping;

      // Wrapped in setState so the widget knows the artboard is ready to play
      setState(() => _artboard = artboard);
    }
  }

  /// Toggle mixing the bounce animation
  void _toggleBounce() =>
      // SimpleAnimation has an isActive flag that can be used to start and
      // stop/pause the animation's playback
      setState(() => _bounceAnimation.isActive = _bouncing = !_bouncing);

  /// Toggle mixing the bounce animation
  void _toggleWipe() =>
      // SimpleAnimation has an isActive flag that can be used to start and
      // stop/pause the animation's playback
      setState(() => _wipersAnimation.isActive = _wiping = !_wiping);

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
            child: Text(_bouncing ? 'Stop Bounce' : 'Start Bounce'),
            onPressed: _toggleBounce,
          ),
        ),
        Flexible(
          flex: 1,
          child: RaisedButton(
            child: Text(_wiping ? 'Stop Wipe' : 'Start Wipe'),
            onPressed: _toggleWipe,
          ),
        ),
      ],
    );
  }
}
