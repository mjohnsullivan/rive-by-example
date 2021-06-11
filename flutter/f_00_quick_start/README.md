# Hello World

Rive's equivlant of a hello world example:

```dart
void main() => runApp(MaterialApp(
      home: Scaffold(
        body: RiveAnimation.network(
          'https://cdn.rive.app/animations/vehicles.riv',
          fit: BoxFit.cover,
        ),
      ),
    ));
```
