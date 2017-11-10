import 'dart:html';

import 'package:monopoly/game/property.dart';
import 'package:monopoly/game/tile.dart';
import 'package:monopoly/graphics/dom.dart';
import 'package:monopoly/graphics/graphics.dart';

class Player {

  int location;
  int _balance;

  bool _isInJail = false;

  String id;
  String name;
  ImageElement token;

  int tokenScale = 1;

  Player(String this.id, String this.name) : location = 0, token = Dom.img()..src = 'res/images/$id.png';

  int get balance => _balance;

  void payRent(int amount) => _balance -= amount;

  void buyProperty(Property purchase) {
    throw new UnimplementedError();
  }

  void mortgageProperty(Property propertyToMortgage) {
    throw new UnimplementedError();
  }

  void upgradeProperty(Property propertyToUpgrade) {
    throw new UnimplementedError();
  }

  void payFine() {
    throw new UnimplementedError();
  }

  void pickToken() {
    throw new UnimplementedError();
  }

  int rollDice() {
    bool turn = true;
    if (turn) {
    }
  }
  /// Render the [Player] on the board
  void render(Graphics g, int x, int y) {
    g.setFillColor('rgba(0, 0, 0, 1)');
    g.fillRect(x * Tile.tileScale + (30 * int.parse(id) % 90), y * Tile.tileScale + 60 * (30 * int.parse(id) ~/ 90), 30, 30);
    g.drawPreloadedImage(token, x * Tile.tileScale + (30 * int.parse(id) % 90), y * Tile.tileScale + 60 * (30 * int.parse(id) ~/ 90), 30, 30);
  }

}