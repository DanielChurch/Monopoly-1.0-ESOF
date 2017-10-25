import 'package:monopoly/graphics/graphics.dart';

import 'tile_type.dart';

class Tile {
  
  TileType type;

  Tile(TileType this.type);

  bool get isProperty => type == TileType.property;

  /// Renders each [Tile] on the board
  void render(Graphics g, double delta) {}

}