import 'package:monopoly/game/board.dart';
import 'package:test/test.dart';

main() {
  group('Board', () {
    test('Board.tiles returns a list of all the tiles on the board', () {
      // There are 40 tiles on the board
      expect(Board.tiles.length, 40);
    });
  });
}