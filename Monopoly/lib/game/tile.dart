import 'tile_type.dart';

class Tile {

  static const Map<String, int> colors = const {'red' : 0, 'blue' : 1};

  TileType type;

  Tile(TileType this.type);

  bool get isProperty => type == TileType.property;

}