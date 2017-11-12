import 'dart:async';
import 'dart:html';
import 'dart:math';

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
  int currentPlayerIndex = 0;

  List<Property> _deeds;

  static Graphics g;

  Element overlay;
  
  DateTime _endTime;
  int mouseX, mouseY;

  static List<Dice> dice = [];
  bool isRolling = false;

  static SpanElement tooltip;

  static bool shouldUpdate = true;

  bool canMortgageProperty = false;
  bool canPayMortgage = false;
  bool canTradeMortgage = false;
  bool canTradeProperty = false;

  Banker(List<Player> this.players, DateTime this._endTime) {
    redrawCanvas(players);
    Dom.body(
        overlay = UserInterface.renderOverlay(),
        UserInterface.buyPropertyOverlay
          ..children[0].onClick.listen(buyProperty)
          ..children[1].onClick.listen(declineProperty),
        tooltip = UserInterface.renderTooltip(),
        UserInterface.renderAllCards(players),
        UserInterface.renderDice()..onClick.listen(rollDice),
        UserInterface.otherButtonGroup,
    );

    UserInterface.finishAuctionButton.onClick.listen(endAuction);
    UserInterface.mortgagePropertyButton.onClick.listen(mortgageProperty);
    UserInterface.payMortgageButton.onClick.listen(payMortgage);
    UserInterface.tradeMortgageButton.onClick.listen(tradeMortgage);
    UserInterface.tradePropertyButton.onClick.listen(tradeProperty);

//    g.canvas.onMousePress.listen((MouseEvent me) {
//
//    });
  }

  void setCanvasListners() {
    g.canvas.onMouseMove.listen((MouseEvent me) {
      int x = (me.client.x - g.canvas.getBoundingClientRect().left).toInt();
      int y = (me.client.y - g.canvas.getBoundingClientRect().top).toInt();

      if (!Board.tiles.where((tile) {
        if (x > tile.x && y > tile.y && x < tile.x + Tile.tileScale && y < tile.y + Tile.tileScale && tile.isProperty) {
          Banker.tooltip.style.visibility = 'visible';
          if (canMortgageProperty || canPayMortgage || canTradeMortgage || canTradeProperty) {
            g.canvas.style.cursor = 'crosshair';
          }
          Banker.tooltip.children.where((child) => child.id == 'name').toList()[0].text = 'Property';
          Banker.tooltip.children.where((child) => child.id == 'money').toList()[0].text = '\$${tile.property.price}';
          Banker.tooltip.children.where((child) => child.id == 'properties').toList()[0].text = 'Owned by ${tile?.property?.owner?.name ?? 'nobody'}';
          return true;
        }
        return false;
      }).toList().isNotEmpty) {
        Banker.tooltip.style.visibility = 'hidden';
        g.canvas.style.cursor = 'default';
      }
    });

//    g.canvas.onMousePress.listen((_) {
//
//    });
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

        tile.x = x * Tile.tileScale;
        tile.y = y * Tile.tileScale;

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

  // Called on rolling the dice for the current player
  Future<Map> rollDice(_, {Map values}) async {
    if (isRolling) return null;
    isRolling = true;
    // Roll the dice
    if (values == null) {
      values = {};
      dice.forEach((dice) {
        int val = Modes.quickroll ? dice.spin(
            upVelocity: 0.0, time: new Duration()) : dice.spin();
        values[val] ??= 0;
        values[val]++;
      });
    }

    if (Modes.quickroll) {
      updatePlayers(values);
      isRolling = false;
    } else {
      new Future.delayed(new Duration(seconds: 3, milliseconds: 500)).then((_) {
        overlay.style.display = 'block';

        updatePlayers(values);

        isRolling = false;

        new Future.delayed(new Duration(seconds: 1, milliseconds: 500)).then((_) => overlay..style.display = 'none');
      });
    }

    return values;
  }

  void endAuction(_) {
    querySelectorAll('#selectedCardContainer').forEach((Element element) {
      Element properties = element.querySelector('#properties');
      players.forEach((player) {
        if (properties.className.contains(player.id)) {
          player.bid = int.parse((properties.children[2] as InputElement).value.replaceAll('\$', ''));
        }
      });
    });

    Board.tiles[players[max(currentPlayerIndex - 1, 0)].location].property.auction(players);
    redrawCanvas(players);
    UserInterface.updateCards(players);
  }

  void buyProperty(_) {
    UserInterface.buyPropertyOverlay.style.display = 'none';
    Board.tiles[players[max(currentPlayerIndex - 1, 0)].location].property.buyProperty(players[max(currentPlayerIndex - 1, 0)]);
    redrawCanvas(players);
    UserInterface.updateCards(players);
  }

  Future<Null> declineProperty(_) async {
    UserInterface.buyPropertyOverlay.style.display = 'none';
    overlay.style.display = 'block';
    overlay.text = 'Time to get shwifty with this auction!';

    await new Future.delayed(new Duration(seconds: 2));

    for (int i = 5; i > 0; i--) {
      overlay.text = '$i';
      await new Future.delayed(new Duration(milliseconds: 500));
    }

    overlay.style.display = 'none';
  }

  void mortgageProperty(_) {
    canMortgageProperty = true;
    overlay.style.display = 'block';
    overlay.text = 'Click on a property to mortgage it';
  }

  void payMortgage(_) {
    canPayMortgage = true;
    overlay.style.display = 'block';
    overlay.text = 'Click on a mortgage to pay it';
  }

  void tradeMortgage(_) {
    canTradeMortgage = true;
    overlay.style.display = 'block';
    overlay.text = 'Click on two mortgages to trade them';
  }

  void tradeProperty(_) {
    canTradeProperty = true;
    overlay.style.display = 'block';
    overlay.text = 'Click on two properties to trade them';
  }

  void endAction(int position, [int position2]) {
    if (canMortgageProperty) {
      Board.tiles[position].property.mortgage();
    } else if (canPayMortgage) {
      Board.tiles[position].property.payMortgage();
    } else if (canTradeMortgage) {
      Board.tiles[position].property.tradeMortgage(Board.tiles[position2], false);
    } else if (canTradeProperty) {
      Board.tiles[position].property.tradeProperty(Board.tiles[position2]);
    }
  }

  /// Updates the players based on the inputted [values] map of the dice rolls
  void updatePlayers (Map values) {
    int sum = 0;
    values.keys.forEach((key) => sum += key * values[key]);

    overlay.text = '$sum';

    players[currentPlayerIndex].updateLocation(sum);

    Tile currentTile = Board.tiles[players[currentPlayerIndex].location];

    if (currentTile.isProperty) {
      Property currentProperty = currentTile.property;
      if (currentProperty.isOwned) {
        currentTile.property.payRent(players[currentPlayerIndex]);
      } else {
        UserInterface.buyPropertyOverlay.style.display = 'block';
        UserInterface.buyPropertyOverlay.children[0].text = 'Buy Property for \$${Board.tiles[players[currentPlayerIndex].location].property.price}';
      }
    }

    // Double roll if length one, don't move on turn
    if (values.keys.where((key) => values[key] == 2).isEmpty) {
      currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    }

    redrawCanvas(players);
    UserInterface.updateCards(players);
    querySelectorAll('#selectedCardContainer').forEach((Element element) {
      if (element.className.contains('$currentPlayerIndex')) {
        element.className += ' selected';
      } else {
        element.className = element.className.replaceAll(' selected', '');
      }
    });
  }

  @visibleForTesting
  set endTime(DateTime endTime) => _endTime = endTime;

  bool sellPropertyToPlayer(Property property) {}

  bool get isWithinMaxTime => new DateTime.now().millisecondsSinceEpoch < _endTime.millisecondsSinceEpoch;

  Player declareWinner() {
    Board.tiles.forEach((Tile tile) {
      if (tile.isProperty) {
        players.forEach((player) {
          if (tile.property.owner.id == player.id) {
            player.balance += tile.property.price;
          }
        });
      }
    });

    int maxBalance = 0;
    players.forEach((player) {
      if (player.balance > maxBalance) {
        maxBalance = player.balance;
      }
    });

    return players.where((player) => player.balance == maxBalance).toList()[0];
  }

  void update() {
    if (!shouldUpdate) return;

    if (!isWithinMaxTime) {
      shouldUpdate = false;
      Player winner = declareWinner();

      window.alert("Winner winner chicken dinner ${winner.name}");
    }
    dice.forEach((d) => d.update());
  }

  void render(double delta) {
    dice.forEach((d) => d.render(delta));
  }

}