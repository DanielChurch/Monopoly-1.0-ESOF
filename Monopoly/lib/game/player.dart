
import 'dart:async';

import 'package:monopoly/game/property.dart';
import 'package:monopoly/graphics/graphics.dart';

class Player {

  int _location;
  int _balance;

  bool _isInJail = false;

  String id;
  String name;
  String token;

  Player(String this.id, String this.name, String this.token);

  int get balance => _balance;
  int get location => _location;

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
  void render(Graphics g) {}

}