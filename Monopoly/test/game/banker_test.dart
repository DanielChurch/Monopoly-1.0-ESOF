import 'dart:async';

import 'package:monopoly/game/banker.dart';
import 'package:monopoly/game/player.dart';
import 'package:test/test.dart';

main() {
  group('Banker', () {
    Banker banker;

    setUp(() {
      banker = new Banker([new Player('1', 'Player 1')], new DateTime.now());
    });

    group('isWithinMaxTime works as expected', () {
      setUp(() {
        banker.endTime = new DateTime.now().add(new Duration(milliseconds: 5));
      });

      test('when the current time is before the end time', () {
        expect(banker.isWithinMaxTime(), isTrue);
      });

      test('when the current time is after the end time', () async {
        await new Future.delayed(new Duration(milliseconds: 5));
        expect(banker.isWithinMaxTime(), isFalse);
      });
    });
  });
}