import 'dart:async';
import 'dart:html';

import 'package:meta/meta.dart';
import 'package:monopoly/graphics/dom.dart';
import 'package:monopoly/graphics/graphics.dart';

import 'dice.dart';
import 'player.dart';
import 'property.dart';
import 'tile.dart';
import 'tile_type.dart';

class Banker {

  int _housesRemaining;

  List<Player> players;
  int _currentPlayerIndex = 0;

  List<Property> _deeds;

  Graphics g;
  
  List<Tile> _board = [
    new Tile(type: TileType.go),
    new Tile(property: new Property(60, 2, "Purple")),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(60, 4, "Purple")),
    new Tile(type: TileType.incomeTax),
    // Railroad is: $25 if owned, $50 for 2, $100 if three, 200 if all owned
    new Tile(property: new Property(200, 25, "Railroad")),
    new Tile(property: new Property(100, 6, "Light-Blue")),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(100, 6, "Light-Blue")),
    new Tile(property: new Property(120, 8, "Light-Blue")),
    new Tile(type: TileType.jail),
    new Tile(property: new Property(140, 10, "Violet")),
    // Utility is 4 x dice roll and 10 x dice roll if both utilities are owned
    new Tile(property: new Property(150, 10, "Utilities")),
    new Tile(property: new Property(140, 10, "Violet")),
    new Tile(property: new Property(160, 12, "Violet")),
    new Tile(property: new Property(200, 25, "Railroad")),
    new Tile(property: new Property(180, 14, "Orange")),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(180, 14, "Orange")),
    new Tile(property: new Property(200, 16, "Orange")),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(220, 18, "Red")),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(220, 18, "Red")),
    new Tile(property: new Property(240, 20, "Red")),
    new Tile(property: new Property(200, 25, "Railroad")),
    new Tile(property: new Property(260, 22, "Yellow")),
    new Tile(property: new Property(260, 22, "Yellow")),
    new Tile(property: new Property(200, 10, "Utility")),
    new Tile(property: new Property(280, 24, "Yellow")),
    new Tile(type: TileType.goToJail),
    new Tile(property: new Property(300, 26, "Dark_Green")),
    new Tile(property: new Property(300, 26, "Dark_Green")),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(320, 28, "Dark_Green")),
    new Tile(property: new Property(200, 25, "Railroad")),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(350, 35, "Dark_Blue")),
    new Tile(type: TileType.luxuryTax),
    new Tile(property: new Property(400, 50, "Dark_Blue"))
  ];
  
  DateTime _endTime;
  int mouseX, mouseY;

  static List<Dice> dice = [];

  static SpanElement tooltip;

  Banker(List<Player> this.players, DateTime this._endTime, this.g) {

    redrawCanvas(g);

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

            _updateLocation(players[_currentPlayerIndex], sum);
            _currentPlayerIndex = _currentPlayerIndex + 1 % (players.length - 1);

            redrawCanvas(g);
            querySelectorAll('#selectedCardContainer').forEach((Element element) {
              if (element.className.contains('$_currentPlayerIndex')) {
                element.className += ' selected';
              } else {
                element.className = element.className.replaceAll(' selected', '');
              }
            });
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

  Future<Null> redrawCanvas(Graphics g) async {
    // Back buffer for double buffering
    Graphics g2 = new Graphics.blank()..setSize(g.width, g.height);

    int x = 0;
    int y = 0;
    int amt = 10;

    int spot = 0;

    await g2.drawImage("res/images/rickandmorty2bg.png", Tile.tileScale, Tile.tileScale, g.width - 2 * Tile.tileScale + 5, g.height - 2 * Tile.tileScale + 5).then((_) async {
      g2.setColor('rgb(255, 255, 0)');
      g2.drawRect(Tile.tileScale + 1, Tile.tileScale + 1, g.width - 2 * Tile.tileScale + 4, g.height - 2 * Tile.tileScale + 4);
      for (Tile tile in _board) {
        tile.render(g2, x, y, 0.0);

        players.forEach((player) {
          if (player.location == spot) {
            player.render(g2, x, y);
          }
        });


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

  Element renderAllCards(List<Player> players) {
    int index = 0;

    return Dom.div(
        players.map((player) => renderCard(player, index++)).toList()
    )
      ..className = 'cardBackground'
      ..style.width = '${10.5 * (index > 2 ? 3 : index)}vw'
      ..style.height = '${28.5 * (index / 3).ceil()}vh';
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
              ..style.right = '.94vw'
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
        )
          ..className = 'cardContainer'
          ..style.height = '${76.0 * 100 / 1087}vh'
          ..style.fontSize = '${16.0 * 100 / 1087}vh'
          ..style.textOverflow = 'clip'
          ..style.overflow = 'hidden'
    )
      ..onMouseEnter.listen((_) {
        Banker.tooltip.style.visibility = 'visible';
        Banker.tooltip.children.where((child) => child.id == 'name').toList()[0].text = '${player.name}';
        Banker.tooltip.children.where((child) => child.id == 'money').toList()[0].text = '\$696969669';
        player.tokenScale = 3;
        redrawCanvas(g);
      })
      ..onMouseLeave.listen((_) {
        Banker.tooltip.style.visibility = 'hidden';
        player.tokenScale = 1;
        redrawCanvas(g);
      })
      ..id = 'selectedCardContainer'
      ..style.position = 'fixed'
      ..className = 'card  ${player.id} ${player.id == '$_currentPlayerIndex' ? 'selected' : ''}'
      ..style.left = '${10.38 * (index % 3) + 65.64}vw' // 9.38
      ..style.top = '${28 * (index ~/ 3) + 1.3 + 2.4}vh' // 23
      ..style.height = '${280 / 1087 * 100}vh'
      ..style.width = '${205 * 100 / 2133}vw';
  }

  void run() {
    if (players.isEmpty) return;

    // Cycle through players and let them do their turn

  }

  @visibleForTesting
  set endTime(DateTime endTime) => _endTime = endTime;

  bool sellPropertyToPlayer(Property property) {}

  bool isWithinMaxTime() => new DateTime.now().millisecondsSinceEpoch < _endTime.millisecondsSinceEpoch;
  Player declareWinner() {}
  bool _updateProperty(Property property) {}

  void _updateLocation(Player player, int amount) {
    player.location = (player.location + amount) % _board.length;
  }

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