@TestOn('chrome')

import 'package:test/test.dart';
import 'package:Monopoly/game/dice.dart';

void main() {
  group('Dice', () {
    Dice dice;

    setUp(() {
      dice = new Dice(0, 0, 0);
    });

    test('spin generaets a random number between 1 and 6', () {
      int roll = dice.spin();
      expect(roll <= 6 && roll >= 1, isTrue);
    });
  });
}