import 'color.dart';
import 'player.dart';

class Property {

  static int housesLeft = 32;
  static int hotelsLeft = 12;
  static const int maxHouses = 4;

  List _rent;
  bool _isMortgaged = false;

  Player owner;

  int _price;
  Color color;

  int numHouses = 0;
  bool isHotel = false;

  Property(int this._price, List this._rent, Color this.color);

  bool get isOwned => owner != null;
  bool get isMortgaged => _isMortgaged;
  List get rent => _rent;
  num get price => isMortgaged ? _price * 1.1 : _price;

  /// Sells the property from the [Banker] to the given [player]
  void buyProperty(Player player) {
    if (player.balance - price >= 0) {
      owner = player;
      player.pay(price);
    }
  }

  /// Sells the property from the current [owner] to the given [player]
  void sellProperty(Player player) {
    if (player.balance - price >= 0 && isOwned) {
      owner.balance += price;
      owner = player;
      player.pay(price);
    }
  }

  void tradeProperty(Property other) {
    if (numHouses == 0 && !isHotel && other.numHouses == 0 && !other.isHotel) {
      Player newOwner = other.owner;
      other.owner = owner;
      owner = newOwner;
    }
  }

  void payRent(Player player) {
    if (isMortgaged) return;

    int price;
    if (isHotel) {
      // Rent is the 6th item in the list
      price = rent[5];
    } else {
      price = rent[numHouses];
    }

    if (isOwned) {
      owner.balance += price;
    }

    player.pay(price);
  }

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

  void buyHouse() {
    if (numHouses < maxHouses && owner.balance - housePrice(true) > 0 && owner == owner && !isHotel) {
      numHouses++;
      owner.pay(housePrice(true));
      housesLeft--;
    } else if (numHouses == maxHouses && owner.balance - housePrice(true) > 0 && owner == owner && !isHotel) {
      numHouses = 0;
      owner.pay(housePrice(true));
      isHotel = true;
    }
  }

  void sellHouse() {
    if (numHouses > 0) {
      numHouses--;
      owner.balance += housePrice(false);
    } else if (isHotel) {
      isHotel = false;
      owner.balance += housePrice(false);
    }
  }

  void mortgage() {
    if (numHouses == 0 && !isHotel && !_isMortgaged) {
      owner.balance += price ~/ 2;
      _isMortgaged = true;
    }
  }

  void payMortgage() {
    if (owner.balance - price > 0 && isMortgaged) {
      owner.pay(price.toInt());
      _isMortgaged = false;
    }
  }

  void tradeMortgage(Property other, bool payImmediately) {
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
      } else if (!payImmediately) {
        // Switch to false to get base price
        _isMortgaged = false;
        other._isMortgaged = false;

        if (owner.balance - (other.price * 0.1).toInt() > 0 && other.owner.balance - (price * 0.1) > 0) {
          switchPlayers();
          owner.pay((other.price * 0.1).toInt());
          other.owner.pay((price * 0.1).toInt());
        }

        // Set back to true
        _isMortgaged = true;
        other._isMortgaged = true;
      }
    }
  }

  void auction(List<Player> players) {
    int max = 0;
    Player winner;

    players.forEach((player) {
      if (player.bid > max) {
        max = player.bid;
        winner = player;
      }
    });

    owner = winner;
    owner.pay(max);
  }

}