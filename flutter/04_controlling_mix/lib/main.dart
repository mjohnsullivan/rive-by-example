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
  SimpleAnimation _bounceAnimation;

  // Level of bounciness (i.e. how much of the bounce animation should be mixed
  // in) from 0 to 1
  double _bounciness = 0;

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
      artboard.addController(
        _bounceAnimation = SimpleAnimation('bouncing', mix: _bounciness),
      );

      // Wrapped in setState so the widget knows the artboard is ready to play
      setState(() => _artboard = artboard);
    }
  }

  /// Sets the level of bounciness
  void _setBounciness(double value) {
    setState(() => _bounceAnimation.mix = _bounciness = value);
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
          child: Slider(
            value: _bounciness,
            min: 0,
            max: 1,
            divisions: 5,
            onChanged: _setBounciness,
          ),
        ),
      ],
    );
  }
}
