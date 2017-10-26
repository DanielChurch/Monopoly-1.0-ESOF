import 'dart:async';
import 'dart:math';
import 'dart:html';

import 'package:monopoly/graphics/dom.dart';
import 'package:vector_math/vector_math.dart';

class Dice {
  Vector3 position;
  Vector3 rotation;
  Vector3 velocity;

  Element box;

  Random random = new Random();

  Dice(num x, num y, num z,
    {Element container})
      : position = new Vector3(0.0, 0.0, 0.0),
        velocity = new Vector3(0.0, 0.0, 0.0) {
    rotation = new Vector3(0.0, 0.0, 0.0);

    container = container ?? Dom.body;

    // Add the dom elements to the container
    container.append(this.box =
      Dom.div(
        ['one', 'two', 'three', 'four', 'five', 'six'].map((className) =>
        Dom.figure(
            Dom.img()
              ..src = 'res/images/dice-$className.png'
              ..className = 'cube'
        )..className = '$className').toList()
      )
        ..id = 'cube'
        ..style.left = '$x'
    );

    box.onClick.listen((_) => spin());
//    box.onMouseMove.listen((_) => spin());
  }

  int offset = 0;

  int spin() {
    // make random rotation to make the dice spin
    rotation.x = random.nextDouble() * 100000;
    rotation.y = random.nextDouble() * 100000;
    rotation.z = random.nextDouble() * 100000;

    // get a random number for the dice to land on when it lands
    int result = random.nextInt(6) + 1;

    // Let the dice spin randomly, then in 1 second set it on path to
    // get to the desired rotate for the calculated random number
    new Future.delayed(new Duration(milliseconds: 1100)).then((_) {
      switch (result) {
        case 1: // Face 1
          rotation.x = rotation.y = rotation.z = 0.0;
          break;
        case 2: // Face 2
          rotation.x = 180.0;
          rotation.y = 0.0;
          rotation.z = 0.0;
          break;
        case 3: // Face 3
          rotation.x = 0.0;
          rotation.y = 270.0;
          rotation.z = 0.0;
          break;
        case 4: // Face 4
          rotation.x = 0.0;
          rotation.y = 90.0;
          rotation.z = 0.0;
          break;
        case 5: // Face 5
          rotation.x = 270.0;
          rotation.y = 0.0;
          rotation.z = 0.0;
          break;
        case 6: // Face 6
          rotation.x = 90.0;
          rotation.y = 0.0;
          rotation.z = 0.0;
          break;
      }
    });

    // Give the dice a force to rocket into the air
    velocity.y = -10.0;

    return result;
  }

  void update() {
    velocity.y += 0.0981;

    position.x += velocity.x;
    position.y += velocity.y;
    position.z += velocity.z;

    if (position.y >= 0) {
      position.y = 0.0;
      velocity.y = 0.0;
    }
  }

  void render(num delta) {
        box.style.transform = '''
           translateX(${position.x}px)
           translateY(${position.y}px)
           translateZ(${position.z}px)
           
           rotateX(${rotation.x}deg)
           rotateY(${rotation.y}deg)
           rotateZ(${rotation.z}deg)
        ''';
  }
}
