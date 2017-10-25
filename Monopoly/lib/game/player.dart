import 'dart:async';

import 'package:monopoly/graphics/graphics.dart';

class Player {

  int _location;
  int _balance;

  bool isInJail;

  String name;
  String token;

  Player(String this.name, String this.token);

  int get balance => _balance;
  int get location => _location;

  void payRent(int amount) => _balance -= amount;

  /// Render the [Player] on the board
  void render(Graphics g) {}

}