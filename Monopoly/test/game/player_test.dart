
import 'package:monopoly/game/player.dart';
import 'package:test/test.dart';

void main() {
  group('Player', () {
    Player player;

    setUp(() {
      player = new Player('1', 'Player 1', '00ff00');
    });

    test('tests run', () {
      expect(true, isTrue);
    });
  });
}