import 'dart:html';
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:monopoly/graphics/dom.dart';
import 'package:monopoly/graphics/graphics.dart';

import 'color.dart';
import 'tile_type.dart';
import 'property.dart';

export 'tile_type.dart';

class Tile {

  /// The current scale of the tiles on the board
  static int tileScale = 96;

  TileType _type;
  Property _property;
  /// [x] and [y] coordinates on the board
  int x, y;

  /// A Map of tile _types and images that are loaded
  static Map<TileType, ImageElement> preloadedImageMap = {
    TileType.property: Dom.img()..src = 'res/images/house.png',
    TileType.freeParking: Dom.img()..src = 'res/images/freeparking1.png',
    TileType.go: Dom.img()..src = 'res/images/go.png',
    TileType.jail: Dom.img()..src = 'res/images/jail.jpg',
    TileType.railroad: Dom.img()..src = 'res/images/railway.png',
    TileType.utility: Dom.img()..src = 'res/images/plumbus.png',
  };

  static ImageElement mortgagedImage = Dom.img()..src = 'res/images/mortgage.png';
  static ImageElement hotelImage = Dom.img()..src = 'res/images/hotel2.png';

  Tile({TileType type, Property property}) : _type = type, _property = property {
    if (_property != null) {
      if (_property.color == Color.railroad) {
        _type = TileType.railroad;
      } else if (_property.color == Color.utility) {
        _type = TileType.utility;
      } else {
        _type = TileType.property;
      }
    }
  }

  TileType get type => _type;
  Property get property => _property;
  bool get isProperty => _type == TileType.property || _type == TileType.railroad || _type == TileType.utility;

  @visibleForTesting
  set type(TileType type) => _type = type;
  @visibleForTesting
  set property(Property property) => _property = property;

  /// Renders each [Tile] on the board
  void render(Graphics g, int x, int y, double delta) {
    // Background
    String color;

    switch(_property?.color ?? Color.utility) {
      case Color.brown: color = 'brown'; break;
      case Color.lightBlue: color = 'blue'; break;
      case Color.purple: color = 'purple'; break;
      case Color.orange: color = 'orange'; break;
      case Color.red: color = 'red'; break;
      case Color.yellow: color = 'yellow'; break;
      case Color.green: color = 'green'; break;
      case Color.darkBlue: color = 'navy'; break;
      case Color.utility: color = 'teal'; break;
      case Color.railroad: color = 'pink'; break;
    }

    g.setFillColor(color ?? 'rgb(${new Random().nextInt(255)}, ${new Random().nextInt(255)}, ${new Random().nextInt(255)})');
    g.fillRect(x * tileScale, y * tileScale, tileScale, tileScale);

    // Border
    g.setColor('rgb(0, 0, 0)');
    g.drawRect(x * tileScale, y * tileScale, tileScale, tileScale);

    // Tile Image
    if (_property?.isMortgaged == true) {
      g.drawPreloadedImage(mortgagedImage, x * tileScale, y * tileScale, tileScale, tileScale);
    } else {
      g.drawPreloadedImage(preloadedImageMap[_type], x * tileScale, y * tileScale, tileScale, tileScale);
    }

    if (_property?.isHotel == true) {
      g.drawPreloadedImage(hotelImage, x * tileScale, y * tileScale, tileScale, tileScale);
    }

    // Owner
    int xOffset = 0;
    int yOffset = 0;

    if (isProperty && _property.isOwned) {
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

      g.drawPreloadedImage(_property.owner.token, x * tileScale + xOffset, y * tileScale + yOffset, tileScale / 4, tileScale / 4);
    }
  }
}