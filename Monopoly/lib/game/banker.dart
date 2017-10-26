import 'dart:html';

import 'package:meta/meta.dart';
import 'package:monopoly/graphics/dom.dart';

import 'dice.dart';
import 'player.dart';
import 'property.dart';
import 'tile.dart';

class Banker {

  int _housesRemaining;

  List<Player> players;
  int _currentPlayerIndex = 0;

  List<Property> _deeds;
  List<Tile> _board;
  DateTime _endTime;

  static List<Dice> dice = [];

  Banker(List<Player> this.players, DateTime this._endTime) {
    // Dice
    Element section = Dom.div(Dom.div()..className = 'cubeContainer')
      ..className = 'cubeContainer'
      ..style.position = 'fixed'
      ..style.left = '1675px'
      ..style.top = '800px'
      ..style.zIndex = '20'
      ..onClick.listen((_) => dice.forEach((dice) => dice.spin()));

    Dom.body(section);

    int x = 0;
    int y = 0;

    // baseWidth 2133
    // baseHeight 1087

    Dom.body(
      Dom.div(
        players.map((player) =>
          Dom.div(
              Dom.div(
                  Dom.img()..src = 'res/images/dogIcon.png'
                    ..style.zIndex = '10'
              )
                ..style.width = '100%'
                ..style.height = '18.4%'
                ..style.background = '#${player.token}'
                ..style.borderRadius = '5px 5px 0 0',
              Dom.div(
                  Dom.p('Player ${player.name}')..style.color = '#ffffff'
              )..className = 'cardContainer'
          )
            ..className = 'card'
            ..style.left = '${10.38 * (x % 3) + 65.64}vw' // 9.38
            ..style.top = '${25 * (x++ ~/ 3) + 4.6 + 5.4}vh' // 23
        ).toList()
      ) // TODO: waaaay too much inline css
        ..style.background = '#333'
        ..style.width = '${10.5 * (x > 2 ? 3 : x)}vw'
        ..style.height = '${25 * (x / 3).ceil()}vh'
        ..style.position = 'fixed'
        ..style.left = '65vw'
        ..style.top = '${3.4 + 5.3}vh'
        ..style.border = '5px solid #555'
    );

    dice.add(new Dice(60.0, 600.0, 0.0, container: section));
    dice.add(new Dice(-60.0, 600.0, 0.0, container: section));
  }

  void run() {
    if (players.isEmpty) return;

    // Cycle through players and let them do their turn

    // End of turn, next players turn
    if (_currentPlayerIndex <= players.length) {
      _currentPlayerIndex++;
    } else {
      _currentPlayerIndex = 0;
    }

  }

  @visibleForTesting
  set endTime(DateTime endTime) => _endTime = endTime;

  bool sellPropertyToPlayer(Property property) {}

  bool isWithinMaxTime() => new DateTime.now().millisecondsSinceEpoch < _endTime.millisecondsSinceEpoch;
  Player declareWinner() {}
  bool _updateProperty(Property property) {}
  void _updateLocation(Player player) {}

  void update() {
    if (isWithinMaxTime()) {
      // End game
    }
    dice.forEach((d) => d.update());
  }

  void render(double delta) {
    dice.forEach((d) => d.render(delta));
  }

}