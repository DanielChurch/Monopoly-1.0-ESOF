import 'dart:async';
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
      int roll = dice.spin(time: new Duration());
      expect(roll <= 6 && roll >= 1, isTrue);
    });

    test('returns the value inputted if there is one', () {
      for (int i = 1; i <= 6; i++) {
        expect(dice.spin(time: new Duration(), value: i), i);
      }
    });

    group('graphics', () {
      test('return normally', () {
        expect(() => dice.update(), returnsNormally);
        expect(() => dice.update(), returnsNormally);
        expect(() => dice.render(0.0), returnsNormally);
        expect(() => dice.spin(time: new Duration(milliseconds: 1)), returnsNormally);
      });
    });
  });
}
