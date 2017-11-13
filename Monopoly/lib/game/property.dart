import 'board.dart';
import 'color.dart';
import 'player.dart';

export 'color.dart';

class Property {

  static int housesLeft = 32;
  static int hotelsLeft = 12;
  static const int maxHouses = 4;

  Player owner;
  Color color;
  int numHouses = 0;
  bool isHotel = false;

  List _rent;
  bool _isMortgaged = false;
  int _price;

  Property(int this._price, List this._rent, Color this.color);

  bool get isOwned => owner != null;
  bool get isMortgaged => _isMortgaged;
  List get rent => _rent;
  num get price => isMortgaged ? _price * 1.1 : _price;

  /// Sells the property from the [Banker] to the given [player]
  bool buyProperty(Player player) {
    if (player.balance - price >= 0) {
      owner = player;
      player.pay(price);
      return true;
    }
    return false;
  }

  /// Sells the property from the current [owner] to the given [player]
  bool sellProperty(Player player) {
    if (!isOwned) return false;

    if (player.balance - price >= 0 && isOwned) {
      owner.balance += price;
      owner = player;
      player.pay(price);
      return true;
    }
    return false;
  }

  /// Trades this property with the [other] property as long as there are not
  /// houses or hotels on either
  bool tradeProperty(Property other) {
    if (!isOwned || !other.isOwned) return false;

    if (numHouses == 0 && !isHotel && other.numHouses == 0 && !other.isHotel) {
      Player newOwner = other.owner;
      other.owner = owner;
      owner = newOwner;
      return true;
    }
    return false;
  }

  /// Makes the [player] pay rent depending on what they land on
  void payRent(Player player, int diceRoll) {
    if (isMortgaged || !isOwned) return;

    int price;
    if (isHotel) {
      // Rent is the 6th item in the list
      price = rent[5];
    } else {
      if (color == Color.utility) {
        int numberOfUtilities = 0;
        Board.tiles.forEach((tile) {
          if (tile.isProperty && tile.property.color == Color.utility && tile.property.owner == owner) {
            numberOfUtilities++;
          }
        });

        price = rent[numberOfUtilities - 1] * diceRoll;
      } else if (color == Color.railroad) {
        int numberOfRailroads = 0;
        Board.tiles.forEach((tile) {
          if (tile.isProperty && tile.property.color == Color.railroad && tile.property.owner == owner) {
            numberOfRailroads++;
          }
        });

        price = rent[numberOfRailroads - 1];
      } else {
        price = rent[numHouses];
      }
    }

    if (isOwned) {
      owner.balance += price;
    }

    player.pay(price);
  }

  /// Returns the price of a house based on color and [isBuying]
  int housePrice(bool isBuying) {
    int price;
    switch(color) {
      case Color.brown:
      case Color.lightBlue:
      case Color.purple: price = 50; break;
      case Color.orange:
      case Color.red: price = 100; break;
      case Color.yellow:
      case Color.green: price = 150; break;
      case Color.darkBlue: price = 200; break;
      case Color.utility:
      case Color.railroad: price = -1;
    }

    return isBuying ? price : price ~/ 2;
  }

  /// Buys a house for this property, subtracting the cost from the owner
  /// If there are 5 houses, it turns into a hotel
  bool buyHouse() {
    if (!isOwned) return false;

    if (numHouses < maxHouses && owner.balance - housePrice(true) > 0 && !isHotel) {
      numHouses++;
      owner.pay(housePrice(true));
      housesLeft--;
      return true;
    } else if (numHouses == maxHouses && owner.balance - housePrice(true) > 0 && !isHotel) {
      numHouses = 0;
      owner.pay(housePrice(true));
      isHotel = true;
      return true;
    }
    return false;
  }

  /// Sells a house and gives the owner money for selling it
  /// If it is a hotel, we sell the whole thing for the price of a single house
  bool sellHouse() {
    if (!isOwned) return false;

    if (numHouses > 0) {
      numHouses--;
      owner.balance += housePrice(false);
      return true;
    } else if (isHotel) {
      isHotel = false;
      owner.balance += housePrice(false);
      return true;
    }
    return false;
  }

  /// Mortgages the property giving the player some temporary money
  bool mortgage() {
    if (!isOwned) return false;

    if (numHouses == 0 && !isHotel && !_isMortgaged && isOwned) {
      owner.balance += price ~/ 2;
      _isMortgaged = true;
      return true;
    }
    return false;
  }

  /// Pays off the mortgage and subtracts the cost from the owner
  bool payMortgage() {
    if (!isOwned) return false;

    if (owner.balance - price > 0 && isMortgaged) {
      owner.pay(price.toInt());
      _isMortgaged = false;
      return true;
    }
    return false;
  }

  /// Trades mortgaged properties between two people
  /// There is an option to pay immediately or later
  /// If immediately, you pay the full price to un mortgage it
  /// Otherwise, you have to pay a small fee of .1 * price
  bool tradeMortgage(Property other, bool payImmediately) {
    if (!isOwned || !other.isOwned) return false;

    void switchPlayers() {
      Player newOwner = other.owner;
      other.owner = owner;
      owner = newOwner;
    }
    if (isMortgaged && other.isMortgaged) {
      if (payImmediately && owner.balance - other.price > 0 && other.owner.balance - price > 0) {
        switchPlayers();

        payMortgage();
        other.payMortgage();
        return true;
      } else if (!payImmediately) {
        // Switch to false to get base price
        _isMortgaged = false;
        other._isMortgaged = false;

        if (owner.balance - (other.price * 0.1).toInt() > 0 && other.owner.balance - (price * 0.1) > 0) {
          switchPlayers();
          owner.pay((other.price * 0.1).toInt());
          other.owner.pay((price * 0.1).toInt());
          return true;
        }

        // Set back to true
        _isMortgaged = true;
        other._isMortgaged = true;
      }
    }
    return false;
  }

  /// Sells the property to the [Player] with the highest bid, for that bid
  bool auction(List<Player> players) {
    int max = 0;
    Player winner;

    players.forEach((player) {
      if (player.bid > max) {
        max = player.bid;
        winner = player;
      }
    });

    if (winner.balance < max) {
      return false;
    }

    owner = winner;
    owner.pay(max);

    return true;
  }

}