import 'tile_type.dart';

class Tile {

  SquareType type;

  Tile(SquareType this.type);

  bool get isProperty => type == SquareType.property;

}