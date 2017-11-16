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

class Banker {

  static List<Dice> dice = [];
  static SpanElement tooltip;
  static Graphics g;

  /// If the main game/animation loop should update
  static bool shouldUpdate = true;

  DateTime _endTime;

  List<Player> players;
  int currentPlayerIndex = 0;
  Element overlay;

  // Booleans to limit the ability of what the user can currently do
  bool canMortgageProperty = false;
  bool canPayMortgage = false;
  bool canTradeMortgage = false;
  bool canTradeProperty = false;
  bool isAuctioning = false;
  bool isRolling = false;
  bool isManagingHouses = false;

  // Temporary tiles to store for when the user is picking them for trade
  Tile tile, tile2;

  Banker(List<Player> this.players, DateTime this._endTime) {
    redrawCanvas(players);
    Dom.body(
        overlay = UserInterface.renderOverlay(),
        UserInterface.buyPropertyOverlay
          ..children[0].onClick.listen(buyProperty)
          ..children[1].onClick.listen(declineProperty),
        UserInterface.payImmediatelyOverlay
          ..children[0].onClick.listen(payMortgageImmediately)
          ..children[1].onClick.listen(payMortgageLater),
        UserInterface.manageHousesOverlay
          ..children[0].onClick.listen((_) => buyHouse(tile))
          ..children[1].onClick.listen((_) => sellHouse(tile)),
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
    UserInterface.manageHousesButton.onClick.listen(manageHouses);
  }

  void setCanvasListeners() {
    g.canvas.onMouseMove.listen((MouseEvent me) {
      int x = (me.client.x - g.canvas.getBoundingClientRect().left).toInt();
      int y = (me.client.y - g.canvas.getBoundingClientRect().top).toInt();

      if (!Board.tiles.where((tile) {
        if (x > (tile.x ?? 0) && y > (tile.y ?? 0) && x < (tile.x ?? 0) + Tile.tileScale && y < (tile.y ?? 0) + Tile.tileScale && tile.isProperty) {
          Banker.tooltip.style.visibility = 'visible';
          if (canMortgageProperty || canPayMortgage || canTradeMortgage || canTradeProperty || isManagingHouses) {
            g.canvas.style.cursor = 'crosshair';
          }
          Banker.tooltip.children.where((child) => child.id == 'name').toList()[0].text = 'Cost: ${tile.property.price} Schmeckles';
          Banker.tooltip.children.where((child) => child.id == 'money').toList()[0].text = 'Rent: ${tile.property.rent}';
          Banker.tooltip.children.where((child) => child.id == 'properties').toList()[0].text = 'Houses: ${tile.property.numHouses}';
          return true;
        }
        return false;
      }).toList().isNotEmpty) {
        Banker.tooltip.style.visibility = 'hidden';
        g.canvas.style.cursor = 'default';
      }
    });

    Tile lastTile;

    g.canvas.onMouseDown.listen((MouseEvent me) {
      int x = (me.client.x - g.canvas.getBoundingClientRect().left).toInt();
      int y = (me.client.y - g.canvas.getBoundingClientRect().top).toInt();

      Board.tiles.forEach((tile) {
        if (x > tile.x && y > tile.y &&
            x < tile.x + Tile.tileScale &&
            y < tile.y + Tile.tileScale && tile.isProperty) {

          if (!tile.isProperty) {
            canTradeMortgage = false;
            canTradeProperty = false;
          }

          if (canMortgageProperty || canPayMortgage) {
            endAction(tile);
          } else {
            if (lastTile == null) {
              lastTile = tile;
            } else {
              endAction(tile, lastTile);
              lastTile = null;
            }
          }
        }
      });
      canMortgageProperty = false;
      canPayMortgage = false;
    });

    void setCanvasSize() {
      g.setSize((window.innerHeight * .96596136154553817847286108555658).toInt(), (window.innerHeight * .96596136154553817847286108555658).toInt());
      Tile.tileScale = (0.08831646734130634774609015639374 * window.innerHeight).toInt();
      redrawCanvas(players);
    };

    setCanvasSize();

    window.onResize.listen((_) => setCanvasSize());
  }

  static Future<Null> redrawCanvas(List<Player> players) async {
    // Back buffer for double buffering
    Graphics g2 = new Graphics.blank()..setSize(g.width, g.height);

    int x = 0;
    int y = 0;
    int amt = 10;

    int spot = 0;

    await g2.drawImage("res/images/rickandmorty2bg.png", Tile.tileScale, Tile.tileScale, g.width - 2 * Tile.tileScale + 5, g.height - 2 * Tile.tileScale + 5).then((_) async {
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
    if (isRolling || isAuctioning) return null;
    isRolling = true;
    // Roll the dice
    if (values == null) {
      values = {};
      dice.forEach((dice) {
        int val = Modes.quickroll ? dice.spin(upVelocity: 0.0, time: new Duration()) : dice.spin();
        values[val] ??= 0;
        values[val]++;
      });
    }

    if (Modes.quickroll) {
      updatePlayers(values);
      isRolling = false;
    } else {
      new Future.delayed(new Duration(seconds: 3, milliseconds: 500)).then((_) {
        updatePlayers(values);

        isRolling = false;
      });
    }

    return values;
  }

  /// Auction Button callback
  /// Ends the auction gives the player with the highest bid the property if valid
  void endAuction(_) {
    if (!isAuctioning) {
      overlayText = 'An auction is not in progress';
      return;
    }

    querySelectorAll('#selectedCardContainer').forEach((Element element) {
      Element properties = element.querySelector('#properties');
      players.forEach((player) {
        if (properties.className.contains(player.id)) {
          player.bid = int.parse((properties.children[2] as InputElement).value.replaceAll(' Schmeckles', ''));
        }
      });
    });

    if (Board.tiles[players[max(currentPlayerIndex - 1, 0)].location].property?.auction(players) != true) {
      overlayText = 'Bid too high';
      return;
    }
    redrawCanvas(players);
    UserInterface.updateCards(players);
    isAuctioning = false;
  }

  /// Callback for buy property button (accept)
  Future<Null> buyProperty(_) async {
    UserInterface.buyPropertyOverlay.style.display = 'none';
    if (!Board.tiles[players[max(currentPlayerIndex - 1, 0)].location].property?.buyProperty(players[max(currentPlayerIndex - 1, 0)])) {
      overlayText = 'Insufficient Funds';

      await new Future.delayed(new Duration(seconds: 2));

      declineProperty(null);
    }
    redrawCanvas(players);
    UserInterface.updateCards(players);
  }

  /// Callback for auction property button (decline)
  Future<Null> declineProperty(_) async {
    isAuctioning = true;
    UserInterface.buyPropertyOverlay.style.display = 'none';
    overlayText = 'Time to get schwifty with this auction!';

    await new Future.delayed(new Duration(seconds: 2));

    overlay.style.display = 'none';
  }

  /// Callback for mortgage property button
  void mortgageProperty(_) {
    setButtonFlags(canMortgageProperty: true);
    overlayText = 'Click on a property to mortgage it';
  }

  /// Callback for pay mortgage button
  void payMortgage(_) {
    setButtonFlags(canPayMortgage: true);
    overlayText = 'Click on a mortgage to pay it';
  }

  /// Callback for trade mortgage button
  void tradeMortgage(_) {
    setButtonFlags(canTradeMortgage: true);
    overlayText = 'Click on two mortgages to trade them';
  }

  /// Callback for trade property button
  void tradeProperty(_) {
    setButtonFlags(canTradeProperty: true);
    overlayText = 'Click on two properties to trade them';
  }

  /// Callback for manage houses button
  void manageHouses(_) {
    setButtonFlags(isManagingHouses: true);
    overlayText = 'Pick a property to manage a house on';
  }

  /// Sets button flags, defaults all to false
  void setButtonFlags({
    bool canMortgageProperty = false,
    bool canPayMortgage = false,
    bool canTradeMortgage = false,
    bool canTradeProperty = false,
    bool isManagingHouses = false,
  }) {
    this.canMortgageProperty = canMortgageProperty ;
    this.canPayMortgage = canPayMortgage ;
    this.canTradeMortgage = canTradeMortgage ;
    this.canTradeProperty = canTradeProperty;
    this.isManagingHouses = isManagingHouses;
  }

  /// Callback for end auction button
  void endAction(Tile tile, [Tile tile2]) {
    if (canMortgageProperty) {
      if (!tile.property.mortgage()) {
        overlayText = 'Mortgage Failed';
      }
    } else if (canPayMortgage) {
      if (!tile.property.payMortgage()) {
        overlayText = 'Mortgage Payment Failed';
      }
    } else if (isManagingHouses) {
      UserInterface.manageHousesOverlay.style.display = 'block';
      this.tile = tile;
    } else if (canTradeMortgage) {
      if (tile == tile2) return;
      this.tile = tile;
      this.tile2 = tile2;
      UserInterface.payImmediatelyOverlay.style.display = 'block';
    } else if (canTradeProperty) {
      if (!tile.property.tradeProperty(tile2.property)) {
        overlayText = 'Failed to trade properties';
      }
    }
    UserInterface.updateCards(players);
    redrawCanvas(players);
  }

  /// Callback for pay mortgage now button
  void payMortgageImmediately(_) {
    if (tile.property.tradeMortgage(tile2.property, true)) {
      overlayText = 'Fail to trade mortgage';
    }
    UserInterface.payImmediatelyOverlay.style.display = 'none';
    UserInterface.updateCards(players);
    redrawCanvas(players);
  }

  /// Callback for pay mortgage later button
  void payMortgageLater(_) {
    if (tile.property.tradeMortgage(tile2.property, false)) {
      overlayText = 'Fail to trade mortgage';
    }
    UserInterface.payImmediatelyOverlay.style.display = 'none';
    UserInterface.updateCards(players);
    redrawCanvas(players);
  }

  /// Callback for buy house button
  void buyHouse(Tile tile) {
    if (!tile.property.buyHouse()) {
      overlayText = 'The property must be owned to buy';
    }
    UserInterface.updateCards(players);
    redrawCanvas(players);
    UserInterface.manageHousesOverlay.style.display = 'none';
  }

  /// Callback for sell house button
  void sellHouse(Tile tile) {
    if (!tile.property.sellHouse()) {
      overlayText = 'The property must be owned to sell';
    }
    UserInterface.updateCards(players);
    redrawCanvas(players);
    UserInterface.manageHousesOverlay.style.display = 'none';
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
        currentTile.property.payRent(players[currentPlayerIndex], sum);
      } else {
        UserInterface.buyPropertyOverlay.style.display = 'block';
        UserInterface.buyPropertyOverlay.children[0].text = 'Buy Property for ${Board.tiles[players[currentPlayerIndex].location].property.price} Schmeckles';
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

  /// If the current time has passed the end time or not
  bool get isWithinMaxTime => new DateTime.now().millisecondsSinceEpoch < _endTime.millisecondsSinceEpoch;

  /// Calculates and returns the [Player] with the highest balance
  Player declareWinner() {
    Board.tiles.forEach((Tile tile) {
      if (tile.isProperty) {
        players.forEach((player) {
          if (tile.property.owner == player) {
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

  /// Sets the overlay text and displays the overlay
  set overlayText(String text) {
    overlay.text = text;
    overlay.style.display = 'block';
  }

  /// Updates the visual game logic, and checks if we exceed the time limit
  /// Alerts the winner if out of time
  void update() {
    // Don't update if the game is over
    if (!shouldUpdate) return;

    if (!isWithinMaxTime) {
      shouldUpdate = false;
      Player winner = declareWinner();

      window.alert("Winner winner chicken dinner ${winner.name}");
    }
    dice.forEach((d) => d.update());
  }

  /// Renders objects that need frequent animation
  void render(double delta) {
    dice.forEach((d) => d.render(delta));
  }

}