import 'dart:async';
import 'dart:math';
import 'dart:html';

import 'package:Monopoly/graphics/dom.dart';

class Dice {
  num lx, ly, lz;
  num x, y, z;
  num velX, velY, velZ;
  num rotX, rotY, rotZ;

  Element box;

  Random random = new Random();

  Dice(this.x, this.y, this.z,
      {this.rotX, this.rotY, this.rotZ, Element container})
      : velX = 0,
        velY = 0,
        velZ = 0,
        lx = x,
        ly = y,
        lz = z {
    this.rotX = rotX ?? 0;
    this.rotY = rotY ?? 0;
    this.rotZ = rotZ ?? 0;

    container = container ?? Dom.body;

    // Add the dom elements to the container
    container.append(this.box = Dom.div(
      ['one', 'two', 'three', 'four', 'five', 'six'].map((className) =>
      Dom.figure(
          Dom.img()
            ..src = 'res/images/dice-$className.png'
            ..className = 'cube'
      )..className = '$className').toList()
    )..id = 'cube');

    box.onClick.listen((_) => spin());
//    box.onMouseMove.listen((_) => spin());
  }

  int offset = 0;

  int spin() {
    // make random rotation to make the dice spin
    rotX = random.nextDouble() * 100000;
    rotY = random.nextDouble() * 100000;
    rotZ = random.nextDouble() * 100000;

    // get a random number for the dice to land on when it lands
    int result = random.nextInt(6) + 1;

    // Let the dice spin randomly, then in 1 second set it on path to
    // get to the desired rotate for the calculated random number
    new Future.delayed(new Duration(milliseconds: 1100)).then((_) {
      switch (result) {
        case 1: // Face 1
          rotX = rotY = rotZ = 0;
          break;
        case 2: // Face 2
          rotX = 180;
          rotY = 0;
          rotZ = 0;
          break;
        case 3: // Face 3
          rotX = 0;
          rotY = 270;
          rotZ = 0;
          break;
        case 4: // Face 4
          rotX = 0;
          rotY = 90;
          rotZ = 0;
          break;
        case 5: // Face 5
          rotX = 270;
          rotY = 0;
          rotZ = 0;
          break;
        case 6: // Face 6
          rotX = 90;
          rotY = 0;
          rotZ = 0;
          break;
      }
    });

    // Give the dice a force to rocket into the air
    velY = -10;

    return result;
  }

  void update() {
    lx = x;
    ly = y;
    lz = z;

    velY += 0.0981;

    x += velX;
    y += velY;
    z += velZ;

    if (y >= 600) {
      y = 600;
      velY = 0;
    }
  }

  void render(num delta) {
    /* Alternative
            translateX(${x * (1 - delta) + delta * lx}px)
            translateY(${y * (1 - delta) + delta * ly}px)
            translateZ(${z * (1 - delta) + delta * lz}px)
     */
    box.style.transform = '''
           translateX(${x}px)
           translateY(${y}px)
           translateZ(${z}px)
           
           rotateX(${rotX}deg)
           rotateY(${rotY}deg)
           rotateZ(${rotZ}deg)
        ''';
  }
}
