import 'dart:html';

import 'package:monopoly/game/property.dart';
import 'package:monopoly/game/tile.dart';
import 'package:monopoly/graphics/dom.dart';
import 'package:monopoly/graphics/graphics.dart';

import 'board.dart';

class Player {

  static const int baseBalance = 1300;

  int _location;
  int balance;

  bool _isInJail = false;

  String id;
  String name;
  ImageElement token;

  int bid = 0;

  int tokenScale = 1;

  Player(String this.id, String this.name) : _location = 0, token = Dom.img()..src = 'res/images/$id.png', balance = baseBalance;

  int get location => _location;

  void updateLocation(int amount) {
    print(_location);
    _location += amount;

    if (location > Board.tiles.length) {
      balance += 200;
    }

    _location %= Board.tiles.length;
  }

  void pay(int amount) => balance -= amount;

  void buyProperty(Property purchase) {
    throw new UnimplementedError();
  }

  void mortgageProperty(Property propertyToMortgage) {
    throw new UnimplementedError();
  }

  void upgradeProperty(Property propertyToUpgrade) {
    throw new UnimplementedError();
  }

  /// Render the [Player] on the board
  void render(Graphics g, int x, int y) {
    g.setFillColor('rgba(0, 0, 0, 1)');
    num relativeTileScale = Tile.tileScale * 0.3125;
    g.fillRect(x * Tile.tileScale + (relativeTileScale * int.parse(id) % (3 * relativeTileScale)), y * Tile.tileScale + (2 * relativeTileScale) * (relativeTileScale * int.parse(id) ~/ (3 * relativeTileScale)), relativeTileScale, relativeTileScale);
    g.drawPreloadedImage(token, x * Tile.tileScale + (relativeTileScale * int.parse(id) % (3 * relativeTileScale)), y * Tile.tileScale + (2 * relativeTileScale) * (relativeTileScale * int.parse(id) ~/ (3 * relativeTileScale)), relativeTileScale, relativeTileScale);
  }

}