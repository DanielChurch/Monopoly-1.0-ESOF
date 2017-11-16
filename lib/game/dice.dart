import 'dart:async';
import 'dart:math';
import 'dart:html';

import 'package:monopoly/graphics/dom.dart';
import 'package:vector_math/vector_math.dart';

class Dice {
  Vector3 _position;
  Vector3 _rotation;
  Vector3 _velocity;

  /// The element containing the dice
  Element _cube;

  Random random = new Random();

  /// Constructs a Dice at the given position ([x], [y], [z]), optionally in the given [container]
  Dice(num x, num y, num z, {Element container})
      : _position = new Vector3(x, 0.0, 0.0),
        _velocity = new Vector3(0.0, 0.0, 0.0),
        _rotation = new Vector3(0.0, 0.0, 0.0) {
    container = container ?? Dom.body();

    // Add the dom elements to the container
    container.append(this._cube =
    Dom.div(
        ['one', 'two', 'three', 'four', 'five', 'six'].map((className) =>
        Dom.figure(
            Dom.img()
              ..src = 'res/images/dice-$className.png'
              ..className = 'cube'
        )
          ..className = '$className').toList()
    )
      ..id = 'cube'
    );
  }

  /// Spin the dice and get a random number
  /// Optionally input:
  ///   - [value] to guarantee rolling that value,
  ///   - [time] to specify how long it will spin for
  ///   - [upVelocity] to specify how far up it will launch
  int spin({int value, Duration time = const Duration(
      milliseconds: 1100), double upVelocity = -0.91996320147194112235510579576817}) {
    // Make random _rotation to make the dice spin
    if (time.inMilliseconds != 0) {
      _rotation.x = random.nextDouble() * 100000;
      _rotation.y = random.nextDouble() * 100000;
      _rotation.z = random.nextDouble() * 100000;
    }

    // get a random number for the dice to land on when it lands
    int result = value ?? random.nextInt(6) + 1;

    // Let the dice spin randomly, then in 1 second set it on path to
    // get to the desired rotate for the calculated random number
    new Future.delayed(time).then((_) {
      switch (result) {
        case 1: // Face 1
          _rotation.x = _rotation.y = _rotation.z = 0.0;
          break;
        case 2: // Face 2
          _rotation.x = 180.0;
          _rotation.y = 0.0;
          _rotation.z = 0.0;
          break;
        case 3: // Face 3
          _rotation.x = 0.0;
          _rotation.y = 270.0;
          _rotation.z = 0.0;
          break;
        case 4: // Face 4
          _rotation.x = 0.0;
          _rotation.y = 90.0;
          _rotation.z = 0.0;
          break;
        case 5: // Face 5
          _rotation.x = 270.0;
          _rotation.y = 0.0;
          _rotation.z = 0.0;
          break;
        case 6: // Face 6
          _rotation.x = 90.0;
          _rotation.y = 0.0;
          _rotation.z = 0.0;
          break;
      }
    });

    // Give the dice a force to rocket into the air
    _velocity.y = upVelocity;

    return result;
  }

  /// Updates the graphical logic of the dice (translation based on gravity and force)
  void update() {
    _velocity.y += 0.00902483900643974241030358785649;

    _position += _velocity;

    if (_position.y >= 0) {
      _position.y = 0.0;
      _velocity.y = 0.0;
    }
  }

  /// Renders the dice with it's current transform (translation, scale)
  void render(num delta) =>
      _cube.style.transform = '''
       translateX(${_position.x}vh)
       translateY(${_position.y}vh)
       translateZ(${_position.z}vh)

       rotateX(${_rotation.x}deg)
       rotateY(${_rotation.y}deg)
       rotateZ(${_rotation.z}deg)
    ''';
}
