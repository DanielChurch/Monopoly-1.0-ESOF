import 'dart:math';

import 'package:monopoly/graphics/graphics.dart';

import 'tile_type.dart';
import 'property.dart';

class Tile {

  static int tileScale = 96;

  TileType type;
  Property property;

  Tile({TileType this.type, Property this.property}){
    if (this.property != null) {
      this.type = TileType.property;
    }
  }

  bool get isProperty => type == TileType.property;

  /// Renders each [Tile] on the board
  void render(Graphics g, int x, int y, double delta) {
    g.setFillColor('rgb(${new Random().nextInt(255)}, ${new Random().nextInt(255)}, ${new Random().nextInt(255)})');
    g.fillRect(x * tileScale, y * tileScale, tileScale, tileScale);
    String imageSrc;
    switch(type) {
      case TileType.property: imageSrc = 'res/images/1.png'; break;
      case TileType.freeParking: imageSrc = 'res/images/2.png'; break;
      case TileType.go: imageSrc = 'res/images/3.png'; break;
      case TileType.goToJail: imageSrc = 'res/images/4.png'; break;
      case TileType.incomeTax: imageSrc = 'res/images/5.png'; break;
      case TileType.jail: imageSrc = 'res/images/6.png'; break;
      case TileType.luxuryTax: imageSrc = 'res/images/1.png'; break;
      case TileType.railroad: imageSrc = 'res/images/1.png'; break;
      case TileType.utility: imageSrc = 'res/images/1.png'; break;
    }
    g.drawImage(imageSrc, x * tileScale, y * tileScale, tileScale, tileScale);
  }
}