import 'dart:async';

import 'package:monopoly/game/banker.dart';
import 'package:monopoly/game/player.dart';
import 'package:monopoly/game/modes.dart';
import 'package:monopoly/graphics/graphics.dart';
import 'package:test/test.dart';

main() {
  group('Banker', () {
    Banker banker;

    setUp(() {
      banker = new Banker([new Player('1', 'Player 1'), new Player('2', 'Player 2')], new DateTime.now());
      Banker.g = new Graphics.blank();
      // Enable quickroll so we don't have to wait on futures
      Modes.uri = new Uri(queryParameters: {'quickroll': ''});
    });

    group('isWithinMaxTime works as expected', () {
      setUp(() {
        banker.endTime = new DateTime.now().add(new Duration(milliseconds: 5));
      });

      test('when the current time is before the end time', () {
        expect(banker.isWithinMaxTime, isTrue);
      });

      test('when the current time is after the end time', () async {
        await new Future.delayed(new Duration(milliseconds: 5));
        expect(banker.isWithinMaxTime, isFalse);
      });
    });

    test('updatePlayers works as intended', () {
      expect(banker.currentPlayerIndex, 0);
      expect(banker.players[banker.currentPlayerIndex].location, 0);
      banker.updatePlayers({1: 1, 2: 1});

      // Moves the player and increments index
      expect(banker.players[0].location, 3);
      expect(banker.currentPlayerIndex, 1);

      // Moves the player and keeps index (since double roll)
      expect(banker.players[banker.currentPlayerIndex].location, 0);
      banker.updatePlayers({2: 2});
      expect(banker.players[0].location, 3);
      expect(banker.currentPlayerIndex, 1);
    });

    test('rollDice rolls the current players dice and moves them', () {
      // Rolls two singles
      banker.rollDice(null, values: {1: 1, 2: 1}).then((roll) {
        expect(banker.currentPlayerIndex, 1);
        expect(banker.players[0].location, 3);
      });

      banker.rollDice(null, values: {1: 2}).then((roll) {
        expect(banker.currentPlayerIndex, 1);
        expect(banker.players[0].location, 3);
      });
    });

    test('declare winner calculates the player with the highest value', () {
      banker.players[0].balance = 1500;
      expect(banker.declareWinner(), banker.players[0]);

      banker.players[1].balance = 1700;
      expect(banker.declareWinner(), banker.players[1]);
    });
  });
}