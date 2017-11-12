import 'dart:html';
import 'dart:math';

import 'package:monopoly/graphics/dom.dart';
import 'package:monopoly/graphics/graphics.dart';

import 'banker.dart';
import 'color.dart';
import 'tile_type.dart';
import 'property.dart';

class Tile {

  static int tileScale = 96;

  TileType type;
  Property property;

  int x, y;

  static Map<TileType, ImageElement> preloadedImageMap = {
    TileType.property: Dom.img()..src = 'res/images/house.png',
    TileType.freeParking: Dom.img()..src = 'res/images/freeparking.png',
    TileType.go: Dom.img()..src = 'res/images/go.png',
    TileType.goToJail: Dom.img()..src = 'res/images/2.png',
    TileType.incomeTax: Dom.img()..src = 'res/images/3.png',
    TileType.jail: Dom.img()..src = 'res/images/jail.jpg',
    TileType.luxuryTax: Dom.img()..src = 'res/images/4.png',
    TileType.railroad: Dom.img()..src = 'res/images/railway.png',
    TileType.utility: Dom.img()..src = 'res/images/plumbus.png',
  };

  Tile({TileType this.type, Property this.property}) {
    if (property != null) {
      if (property.color == Color.railroad) {
        type = TileType.railroad;
      } else if (property.color == Color.utility) {
        type = TileType.utility;
      } else {
        type = TileType.property;
      }
    }
  }

  bool get isProperty => type == TileType.property || type == TileType.railroad || type == TileType.utility;

  /// Renders each [Tile] on the board
  void render(Graphics g, int x, int y, double delta) {
    // Background
    String color;

    switch(property?.color ?? Color.utility) {
      case Color.brown: color = 'brown'; break;
      case Color.lightBlue: color = 'cyan'; break;
      case Color.purple: color = 'purple'; break;
      case Color.orange: color = 'orange'; break;
      case Color.red: color = 'red'; break;
      case Color.yellow: color = 'yellow'; break;
      case Color.green: color = 'green'; break;
      case Color.darkBlue: color = 'blue'; break;
      case Color.utility: color = 'teal'; break;
      case Color.railroad: color = 'pink'; break;
    }

    g.setFillColor(color ?? 'rgb(${new Random().nextInt(255)}, ${new Random().nextInt(255)}, ${new Random().nextInt(255)})');
    g.fillRect(x * tileScale, y * tileScale, tileScale, tileScale);
    // Border
    g.setColor('rgb(0, 0, 0)');
    g.drawRect(x * tileScale, y * tileScale, tileScale, tileScale);
    // Tile Image
    g.drawPreloadedImage(preloadedImageMap[type], x * tileScale, y * tileScale, tileScale, tileScale);

    int xOffset = 0;
    int yOffset = 0;

    if (isProperty && property.isOwned) {
      if (x == 0) {
        xOffset = tileScale;
        yOffset = tileScale ~/ 3;
      } else if (y == 0) {
        yOffset = tileScale;
        xOffset = tileScale ~/ 3;
      } else if (x == 10) {
        xOffset = -tileScale ~/ 4;
        yOffset = tileScale ~/ 3;
      } else if (y == 10) {
        yOffset = -tileScale ~/ 4;
        xOffset = tileScale ~/ 3;
      }

      g.drawPreloadedImage(property.owner.token, x * tileScale + xOffset, y * tileScale + yOffset, tileScale / 4, tileScale / 4);
    }
  }
}