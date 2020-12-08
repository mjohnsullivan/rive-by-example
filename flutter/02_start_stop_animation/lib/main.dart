import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Start and Stop a Looping Animation',
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
  SimpleAnimation _animation;
  var _playing = true;

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
      // Create a SimpleAnimation controller for the animation you want to play
      // and attach it to the artboard. Keep a reference to the controller to
      // start and stop it.
      artboard.addController(_animation = SimpleAnimation('idle'));
      // Wrapped in setState so the widget knows the animation is ready to play
      setState(() => _artboard = artboard);
    }
  }

  /// Toggle animation playback and button states
  void _togglePlayback() =>
      // SimpleAnimation has an isActive flag that can be used to start and
      // stop/pause the animation's playback
      setState(() => _animation.isActive = _playing = !_playing);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 1,
          child: _artboard != null ? Rive(artboard: _artboard) : Container(),
        ),
        Flexible(
          flex: 1,
          child: RaisedButton(
            child: Text(_playing ? 'Stop' : 'Start'),
            onPressed: _togglePlayback,
          ),
        ),
      ],
    );
  }
}
