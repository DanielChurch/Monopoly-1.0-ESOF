import 'dart:html';

import 'package:test/test.dart';
import 'package:monopoly/game/dice.dart';
import 'package:monopoly/graphics/dom.dart';

void main() {
  group('Dice', () {
    Dice dice;

    setUp(() {
      dice = new Dice(0.0, 0.0, 0.0);
    });

    test('correctly appends to the passed in container dom', () {
      Element div = Dom.div();
      expect(div.children, isEmpty);
      dice = new Dice(0.0, 0.0, 0.0, container: div);
      expect(div.children, isNotEmpty);
    });

    test('spin generaets a random number between 1 and 6', () {
      int roll = dice.spin();
      expect(roll <= 6 && roll >= 1, isTrue);
    });

    test('returns the value inputted if there is one', () {
      expect(dice.spin(value: 3), 3);
    });
  });
}