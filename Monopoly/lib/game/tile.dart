import 'tile_type.dart';


class Tile {

  static const Map<String, int> colors = const {'red' : 0, 'blue' : 1};

  //Color color;

  TileType type;

  Tile(TileType this.type);

  bool get isProperty => type == TileType.property;

}