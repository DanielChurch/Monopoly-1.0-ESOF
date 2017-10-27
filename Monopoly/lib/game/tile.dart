import 'package:monopoly/graphics/dom.dart';
import 'package:monopoly/graphics/graphics.dart';

import 'tile_type.dart';

class Tile {
  
  TileType type;

  Tile(TileType this.type);

  bool get isProperty => type == TileType.property;

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

}