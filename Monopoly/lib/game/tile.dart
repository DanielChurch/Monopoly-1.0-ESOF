<<<<<<< HEAD
import 'tile_type.dart';


class Tile {

  static const Map<String, int> colors = const {'red' : 0, 'blue' : 1};

  //Color color;

=======
import 'package:monopoly/graphics/dom.dart';
import 'package:monopoly/graphics/graphics.dart';

import 'tile_type.dart';

class Tile {
  
>>>>>>> 06d9e7b68ba1bcd74dd5e966699b6b2133e1c595
  TileType type;

  Tile(TileType this.type);

  bool get isProperty => type == TileType.property;

<<<<<<< HEAD
=======
  /// Renders each [Tile] on the board
  void render(Graphics g, double delta) {
    // g.setColor(color); // Need property color setup
    // g.fillRect(0, 0, 50, 50);
    String imageSrc;
    switch(type) {
      case TileType.property: imageSrc = ''; break;
      case TileType.freeParking: imageSrc = ''; break;
      case TileType.go: imageSrc = ''; break;
      case TileType.goToJail: imageSrc = ''; break;
      case TileType.incomeTax: imageSrc = ''; break;
      case TileType.jail: imageSrc = ''; break;
      case TileType.luxuryTax: imageSrc = ''; break;
    }
    g.drawImage(Dom.img(imageSrc), 0, 0, 50, 50);
  }

>>>>>>> 06d9e7b68ba1bcd74dd5e966699b6b2133e1c595
}