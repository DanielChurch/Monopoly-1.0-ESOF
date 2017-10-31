import 'dart:async';
import 'dart:html';

import 'package:meta/meta.dart';
import 'package:monopoly/graphics/dom.dart';

import 'dice.dart';
import 'player.dart';
import 'property.dart';
import 'tile.dart';
import 'tile_type.dart';

class Banker {

  int _housesRemaining;

  List<Player> players;
  int _currentPlayerIndex = 1;

  List<Property> _deeds;
  
  List<Tile> _board = [
    new Tile(TileType.go),
    new Tile(TileType.property),
    new Tile(TileType.freeParking),
    new Tile(TileType.property),
    new Tile(TileType.incomeTax),
    new Tile(TileType.railroad),
    new Tile(TileType.property),
    new Tile(TileType.freeParking),
    new Tile(TileType.property),
    new Tile(TileType.property),
    new Tile(TileType.jail),
    new Tile(TileType.property),
    new Tile(TileType.utility),
    new Tile(TileType.property),
    new Tile(TileType.property),
    new Tile(TileType.railroad),
    new Tile(TileType.property),
    new Tile(TileType.freeParking),
    new Tile(TileType.property),
    new Tile(TileType.property),
    new Tile(TileType.freeParking),
    new Tile(TileType.property),
    new Tile(TileType.freeParking),
    new Tile(TileType.property),
    new Tile(TileType.property),
    new Tile(TileType.railroad),
    new Tile(TileType.property),
    new Tile(TileType.property),
    new Tile(TileType.utility),
    new Tile(TileType.property),
    new Tile(TileType.goToJail),
    new Tile(TileType.property),
    new Tile(TileType.property),
    new Tile(TileType.freeParking),
    new Tile(TileType.property),
    new Tile(TileType.railroad),
    new Tile(TileType.freeParking),
    new Tile(TileType.property),
    new Tile(TileType.luxuryTax),
    new Tile(TileType.property)
  ];
  
  DateTime _endTime;
  int mouseX, mouseY;

  static List<Dice> dice = [];

  static SpanElement tooltip;

  Banker(List<Player> this.players, DateTime this._endTime) {

    Element overlay;

    Dom.body(
        overlay = Dom.div()
          ..onClick.listen((_) => Banker.tooltip.style.display = 'none')
          ..id = 'overlay'
          ..style.color = '#fff'
          ..style.display = 'none'
          ..style.zIndex = '50'
    );

    // Dice
    Element section = Dom.div(Dom.div()..className = 'cubeContainer')
      ..className = 'cubeContainer'
      ..style.position = 'fixed'
      ..style.left = '78.53vw'
      ..style.top = '73.6vh'
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

    // baseWidth 2133
    // baseHeight 1087

    //Tooltip
    tooltip = Dom.span(
      Dom.div()..id = 'name',
      Dom.p(),
      Dom.div()..id = 'money',
      Dom.p(),
      Dom.div('Tooltip Line 3')..id = 'properties'
    )
      ..className = 'tooltip tooltiptext'
      ..style.width = '200px';

    Dom.body(tooltip);

    window.onMouseMove.listen((MouseEvent me) {
      mouseX = me.client.x;
      mouseY = me.client.y;

      Banker.tooltip
        ..style.left = '${me.client.x - 100}px' // 4.69
        ..style.top = '${me.client.y + 20}px';
    });

    Dom.body(renderAllCards(players));

    dice.add(new Dice(60.0, 600.0, 0.0, container: section));
    dice.add(new Dice(-60.0, 600.0, 0.0, container: section));
  }

  Element renderAllCards(List<Player> players) {
    int index = 0;

    return Dom.div(
        players.map((player) => renderCard(player, index++)).toList()
    )
      ..className = 'cardBackground'
      ..style.width = '${10.5 * (index > 2 ? 3 : index)}vw'
      ..style.height = '${28.5 * (index / 3).ceil()}vh'
      ..onClick.listen((_) {
        _currentPlayerIndex++;
      });
  }

  Element renderCard(Player player, int index) {
    return Dom.div(
        Dom.div(
            Dom.img()
              ..src = 'res/images/${player.id}.png'
              ..style.width = '7.03vw'
              ..style.height = '13.8vh'
              ..style.position = 'absolute'
              ..style.bottom = '0'
              ..style.right = '25px'
              ..style.margin = 'auto'
        )
          ..className = 'cardImage'
          ..style.background = 'url(res/images/charBackround_${player.id}.png)' // #${player.token}
          ..style.height = '18.4vh'
          ..style.backgroundSize = 'cover'
          ..style.backgroundRepeat = 'no-repeat'
          ..style.backgroundPosition = 'center center',
        Dom.div(
          Dom.div('${player.name}'),
          Dom.div('\$6969696969696'),
          Dom.div('Properties'),
          Dom.div('Line1'),
        )..className = 'cardContainer'
    )
      ..onMouseEnter.listen((_) {
        Banker.tooltip.style.visibility = 'visible';
        Banker.tooltip.children.where((child) => child.id == 'name').toList()[0].text = '${player.name}';
        Banker.tooltip.children.where((child) => child.id == 'money').toList()[0].text = '\$696969669';
      })
      ..onMouseLeave.listen((_) => Banker.tooltip.style.visibility = 'hidden')
      ..style.position = 'fixed'
      ..className = 'card ${player.id == '$_currentPlayerIndex' ? 'selected' : ''}'
      ..style.left = '${10.38 * (index % 3) + 65.64}vw' // 9.38
      ..style.top = '${28 * (index ~/ 3) + 1.3 + 2.4}vh'; // 23
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