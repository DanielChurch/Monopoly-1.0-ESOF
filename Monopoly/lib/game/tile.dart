import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:monopoly/graphics/dom.dart';
import 'package:monopoly/graphics/graphics.dart';

import 'tile_type.dart';
import 'property.dart';

class Tile {

  static int tileScale = 96;

  TileType type;
  Property property;

  static Map<TileType, ImageElement> preloadedImageMap = {
    TileType.property: Dom.img()..src = 'res/images/1.png',
    TileType.freeParking: Dom.img()..src = 'res/images/freeParking.jpg',
    TileType.go: Dom.img()..src = 'res/images/go.png',
    TileType.goToJail: Dom.img()..src = 'res/images/2.png',
    TileType.incomeTax: Dom.img()..src = 'res/images/3.png',
    TileType.jail: Dom.img()..src = 'res/images/jail.jpg',
    TileType.luxuryTax: Dom.img()..src = 'res/images/4.png',
    TileType.railroad: Dom.img()..src = 'res/images/5.png',
    TileType.utility: Dom.img()..src = 'res/images/0.png',
  };

  Tile({TileType this.type, Property this.property}) {
    if (this.property != null) {
      this.type = TileType.property;
    }
  }

  bool get isProperty => type == TileType.property;

  /// Renders each [Tile] on the board
  void render(Graphics g, int x, int y, double delta) {
    // Background
    g.setFillColor(property?.color ?? 'rgb(${new Random().nextInt(255)}, ${new Random().nextInt(255)}, ${new Random().nextInt(255)})');
    g.fillRect(x * tileScale, y * tileScale, tileScale, tileScale);
    // Border
    g.setColor('rgb(0, 0, 0)');
    g.drawRect(x * tileScale, y * tileScale, tileScale, tileScale);
    // Tile Image
    g.drawPreloadedImage(preloadedImageMap[type], x * tileScale, y * tileScale, tileScale, tileScale);
  }
}