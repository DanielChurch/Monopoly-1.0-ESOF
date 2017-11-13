import 'package:monopoly/game/property.dart';
import 'package:monopoly/game/tile.dart';
import 'package:test/test.dart';

void main() {
  group('Tile', () {
    Tile tile;

    setUp(() {
      tile = new Tile(property: new Property(200, [], Color.darkBlue));
    });

    test('isProperty returns true if the tile is a property, railroad, or utility', () {
      List propertyTiles = [TileType.property, TileType.utility, TileType.railroad]
        ..forEach((type) {
          tile.type = type;
          expect(tile.isProperty, isTrue);
        });

      List tiles = new List.from(TileType.values);

      propertyTiles.forEach((type) => tiles.remove(type));

      // List of non property tiles
      tiles.forEach((type) {
        tile.type = type;
        expect(tile.isProperty, isFalse);
      });
    });

    test("type returns the tile's _type", () {

    });

    group('graphics', () {
      test('render', () {

      });
    });

  });
}
