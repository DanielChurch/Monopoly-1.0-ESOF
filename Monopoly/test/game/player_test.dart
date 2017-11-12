import 'package:monopoly/game/player.dart';
import 'package:test/test.dart';

void main() {
  group('Player', () {
    Player player;

    setUp(() {
      player = new Player('1', 'Player 1');
    });

    group('updateLocation', () {
      test('updates the location as intended', () {
        expect(player.location, 0);
        player.updateLocation(5);
        expect(player.location, 5);
      });

      test('loops and gives the player \$200 if passing 40', () {
        expect(player.location, 0);
        expect(player.balance, Player.baseBalance);
        player.updateLocation(41);
        expect(player.location, 1);
        expect(player.balance, 1500);
      });
    });

    test('pay correctly takes away from the players balance', () {
      expect(player.balance, Player.baseBalance);
      player.pay(200);
      expect(player.balance, 1100);
    });
  });
}