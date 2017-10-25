import 'dart:async';
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
    Element section = Dom.div()
      ..className = 'cubeContainer'
      ..style.transform = 'translateX(1000px)'
      ..onClick.listen((_) => dice.forEach((dice) => dice.spin()));

    /*
    <div class="card">
      <img src="img_avatar.png" alt="Avatar" style="width:100%">
      <div class="container">
        <h4><b>John Doe</b></h4>
        <p>Architect & Engineer</p>
      </div>
    </div>
     */

    /*
    Dom.div(
      Dom.div(
        Dom.div()
          ..style.background = '#${player.token}'
          ..id = 'right',
        'Player ${player.name}',
      )..className = 'chip chipContainer',
      Dom.hr()
    )
     */
    /*
    <div class="card">
      <img src="img_avatar.png" alt="Avatar" style="width:100%">
      <div class="container">
        <h4><b>John Doe</b></h4>
        <p>Architect & Engineer</p>
      </div>
    </div>
     */

    Dom.body(section);

    Dom.body(
      Dom.span(
        players.map((player) =>
          Dom.div(
              Dom.div(
                  Dom.img()..src = 'res/images/dogIcon.png'
              )
                ..style.width = '100%'
                ..style.height = '200px'
                ..style.background = '#${player.token}',
              Dom.div(
                  Dom.p('Player ${player.name}')..style.color = '#ffffff'
              )..className = 'cardContainer'
          )..className = 'card'
        ).toList()
      )
    );

    dice.add(new Dice(120.0, 600.0, 0.0, container: section));
    dice.add(new Dice(0.0, 600.0, 0.0, container: section));
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