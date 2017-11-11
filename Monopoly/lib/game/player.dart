import 'dart:html';

import 'package:monopoly/game/property.dart';
import 'package:monopoly/game/tile.dart';
import 'package:monopoly/graphics/dom.dart';
import 'package:monopoly/graphics/graphics.dart';

class Player {

  int location;
  int balance;

  bool _isInJail = false;

  String id;
  String name;
  ImageElement token;

  int tokenScale = 1;

  Player(String this.id, String this.name) : location = 0, token = Dom.img()..src = 'res/images/$id.png', balance = 1300;

  void payRent(int amount) => balance -= amount;

  void buyProperty(Property purchase) {
    throw new UnimplementedError();
  }

  void mortgageProperty(Property propertyToMortgage) {
    throw new UnimplementedError();
  }

  void upgradeProperty(Property propertyToUpgrade) {
    throw new UnimplementedError();
  }

  void payFine(int amount) {
    balance -= amount;
  }

  /// Render the [Player] on the board
  void render(Graphics g, int x, int y) {
    g.setFillColor('rgba(0, 0, 0, 1)');
    g.fillRect(x * Tile.tileScale + (30 * int.parse(id) % 90), y * Tile.tileScale + 60 * (30 * int.parse(id) ~/ 90), 30, 30);
    g.drawPreloadedImage(token, x * Tile.tileScale + (30 * int.parse(id) % 90), y * Tile.tileScale + 60 * (30 * int.parse(id) ~/ 90), 30, 30);
  }

}