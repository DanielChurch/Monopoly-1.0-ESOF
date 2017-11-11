import 'dart:async';
import 'dart:html';

import 'package:meta/meta.dart';
import 'package:monopoly/graphics/dom.dart';
import 'package:monopoly/graphics/graphics.dart';

import 'board.dart';
import 'dice.dart';
import 'modes.dart';
import 'player.dart';
import 'property.dart';
import 'tile.dart';
import 'ui.dart';

// baseWidth 2133
// baseHeight 1087

class Banker {

  int _housesRemaining;

  List<Player> players;
  int _currentPlayerIndex = 0;

  List<Property> _deeds;

  static Graphics g;

  Element overlay;
  
  DateTime _endTime;
  int mouseX, mouseY;

  static List<Dice> dice = [];

  static SpanElement tooltip;

  Banker(List<Player> this.players, DateTime this._endTime) {
    redrawCanvas(players);
    Dom.body(
        overlay = UserInterface.renderOverlay(),
        tooltip = UserInterface.renderTooltip(),
        UserInterface.renderAllCards(players),
        UserInterface.renderDice()..onClick.listen(rollDice),
    );
  }

  static Future<Null> redrawCanvas(List<Player> players) async {
    // Back buffer for double buffering
    Graphics g2 = new Graphics.blank()..setSize(g.width, g.height);

    int x = 0;
    int y = 0;
    int amt = 10;

    int spot = 0;

    await g2.drawImage("res/images/rickandmorty2bg.png", Tile.tileScale, Tile.tileScale, g.width - 2 * Tile.tileScale + 5, g.height - 2 * Tile.tileScale + 5).then((_) async {
      g2.setColor('rgb(255, 255, 0)');
      g2.drawRect(Tile.tileScale + 1, Tile.tileScale + 1, g.width - 2 * Tile.tileScale + 4, g.height - 2 * Tile.tileScale + 4);
      for (Tile tile in Board.tiles) {
        tile.render(g2, x, y, 0.0);

        List playersOnSpot = players.where((player) => player.location == spot).toList();

        // TODO: custom rendered based on [playersOnSpot.length]
        playersOnSpot.forEach((player) => player.render(g2, x, y));

        if (x != amt && y == 0) {
          x++;
        } else if (x == amt && y != amt) {
          y++;
        } else if(x != 0 && y == amt) {
          x--;
        } else if (x == 0 && y != 0) {
          y--;
        }

        spot++;
      };
    });

    g.drawCanvas(g2.canvas);
  }

  Future<Null> rollDice(_) async {
    Map values = {};
    dice.forEach((dice) {
      int val = Modes.quickroll ? dice.spin(upVelocity: 0.0, time: new Duration()) : dice.spin();
      values[val] ??= 0;
      values[val]++;
    });

    void updatePlayers () {
      int sum = 0;
      values.keys.forEach((key) => sum += key * values[key]);

      overlay.text = '$sum';

      int lastPlayerIndex = _currentPlayerIndex;

      players[_currentPlayerIndex].updateLocation(sum);

      // Double roll if length one, don't move on turn
      if (values.keys.where((key) => values[key] == 2).isEmpty) {
        _currentPlayerIndex = (_currentPlayerIndex + 1) % players.length;
      }

      redrawCanvas(players);
      querySelectorAll('#selectedCardContainer').forEach((Element element) {
        if (element.className.contains('$_currentPlayerIndex')) {
          element.className += ' selected';
        } else {
          element.className = element.className.replaceAll(' selected', '');
        }

        if (element.className.contains('$lastPlayerIndex')) {
          element.querySelector('#properties').children[1].text = '\$${players[lastPlayerIndex].balance}';
        }
      });
    }

    if (Modes.quickroll) {
      updatePlayers();
    } else {
      new Future.delayed(new Duration(seconds: 3, milliseconds: 500)).then((_) {
        overlay.style.display = 'block';

        updatePlayers();

        new Future.delayed(new Duration(seconds: 1, milliseconds: 500)).then((_) => overlay..style.display = 'none');
      });
    }
  }

  @visibleForTesting
  set endTime(DateTime endTime) => _endTime = endTime;

  bool sellPropertyToPlayer(Property property) {}

  bool isWithinMaxTime() => new DateTime.now().millisecondsSinceEpoch < _endTime.millisecondsSinceEpoch;
  Player declareWinner() {}
  bool _updateProperty(Property property) {}

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