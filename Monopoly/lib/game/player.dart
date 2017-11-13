import 'dart:html';

import 'package:monopoly/graphics/dom.dart';
import 'package:monopoly/graphics/graphics.dart';

import 'board.dart';
import 'tile.dart';

class Player {

  static const int baseBalance = 1300;

  String id;
  String name;

  int balance;
  int bid = 0;
  int tokenScale = 1;

  ImageElement token;

  int _location;

  Player(String this.id, String this.name) : _location = 0, token = Dom.img()..src = 'res/images/$id.png', balance = baseBalance;

  int get location => _location;

  /// Moves the player the by [amount]
  void updateLocation(int amount) {
    print(_location);
    _location += amount;

    if (location > Board.tiles.length) {
      balance += 200;
    }

    _location %= Board.tiles.length;
  }

  /// Makes the player pay and subtracts the the [amount] from the [balance]
  void pay(int amount) => balance -= amount;

  /// Render the [Player] on the board
  void render(Graphics g, int x, int y) {
    g.setFillColor('rgba(0, 0, 0, 1)');
    num relativeTileScale = Tile.tileScale * 0.3125;
    g.fillRect(x * Tile.tileScale + (relativeTileScale * int.parse(id) % (3 * relativeTileScale)), y * Tile.tileScale + (2 * relativeTileScale) * (relativeTileScale * int.parse(id) ~/ (3 * relativeTileScale)), relativeTileScale, relativeTileScale);
    g.drawPreloadedImage(token, x * Tile.tileScale + (relativeTileScale * int.parse(id) % (3 * relativeTileScale)), y * Tile.tileScale + (2 * relativeTileScale) * (relativeTileScale * int.parse(id) ~/ (3 * relativeTileScale)), relativeTileScale, relativeTileScale);
  }

}