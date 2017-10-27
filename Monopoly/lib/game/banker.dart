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
  int _currentPlayerIndex = 1;

  List<Property> _deeds;
  List<Tile> _board;
  DateTime _endTime;

  int mouseX, mouseY;

  static List<Dice> dice = [];

  Banker(List<Player> this.players, DateTime this._endTime) {
    Element overlay;

    Dom.body(
        overlay = Dom.div()
          ..onClick.listen((_) => overlay.style.display = 'none')
          ..id = 'overlay'
          ..style.color = '#fff'
          ..style.display = 'none'
          ..style.zIndex = '50'
    );

    // Dice
    Element section = Dom.div(Dom.div()..className = 'cubeContainer')
      ..className = 'cubeContainer'
      ..style.position = 'fixed'
      ..style.left = '1675px'
      ..style.top = '800px'
      ..style.zIndex = '20'
      ..onClick.listen((_) async {
          int sum = 0;
          dice.forEach((dice) => sum += dice.spin());
          new Future.delayed(new Duration(seconds: 3, milliseconds: 500)).then((_) {
            overlay.text = '$sum';
            overlay.style.display = 'block';
            new Future.delayed(new Duration(seconds: 1, milliseconds: 500)).then((_) => overlay.style.display = 'none');
          });
      });

    Dom.body(section);

    int x = 0;
    int y = 0;

    // baseWidth 2133
    // baseHeight 1087

    //Tooltip
    SpanElement tooltip = Dom.span(
      Dom.div()..id = 'name',
      Dom.p(),
      Dom.div()..id = 'money',
      Dom.p(),
      Dom.div('all of dem')..id = 'properties'
    )
      ..className = 'tooltip tooltiptext'
      ..style.width = '200px';

    Dom.body(tooltip);

    window.onMouseMove.listen((MouseEvent me) {
      mouseX = me.client.x;
      mouseY = me.client.y;

      tooltip
        ..style.left = '${me.client.x - 100}px'
        ..style.top = '${me.client.y + 20}px';
    });

    Dom.body(
      Dom.div(
        players.map((player) =>
          Dom.div(
              Dom.div(
                  Dom.img()..src = 'res/images/dogIcon.png'
                    ..style.zIndex = '10'
                    ..style.position = 'relative'
              )
                ..style.position = 'relative'
                ..style.width = '100%'
                ..style.height = '18.4%'
                ..style.background = '#${player.token}'
                ..style.borderRadius = '5px 5px 0 0',
              Dom.div(
                  Dom.p('Player ${player.name}')..style.color = '#ffffff',
                  Dom.p('\$6969696969696')..style.color = '#ffffff',
              )..className = 'cardContainer'
          )
            ..onMouseEnter.listen((_) {
              tooltip.style.visibility = 'visible';
              tooltip.children.where((child) => child.id == 'name').toList()[0].text = 'Player ${player.name}';
              tooltip.children.where((child) => child.id == 'money').toList()[0].text = '\$696969669';
            })
            ..onMouseLeave.listen((_) => tooltip.style.visibility = 'hidden')
            ..style.position = 'fixed'
            ..className = 'card ${player.name == '$_currentPlayerIndex' ? 'selected' : ''}'
            ..style.left = '${10.38 * (x % 3) + 65.64}vw' // 9.38
            ..style.top = '${28 * (x++ ~/ 3) + 1.3 + 2.4}vh' // 23
        ).toList()
      )
        ..style.background = '#333'
        ..style.width = '${10.5 * (x > 2 ? 3 : x)}vw'
        ..style.height = '${28.5 * (x / 3).ceil()}vh'
        ..style.position = 'fixed'
        ..style.left = '64.75vw'
        ..style.top = '${2}vh'
        ..style.border = '5px solid #555'
        ..style.borderRadius = '10px'
        ..onClick.listen((_) {
            _currentPlayerIndex++;
        })
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