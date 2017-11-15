import 'package:monopoly/game/color.dart';
import 'package:monopoly/game/property.dart';
import 'package:monopoly/game/player.dart';
import 'package:test/test.dart';

void main() {
  group('Property', () {
    Property property;
    Player player;
    Player owner;

    setUp(() {
      property = new Property(20, [1, 2, 3, 4, 5, 6], Color.darkBlue);
      player = new Player('0', 'Player 1');
      owner = new Player('1', 'Owner');
    });

    test('constructs properly', () {
      expect(property.color, Color.darkBlue);
      expect(property.price, 20);
    });

    group('buyProperty', () {
      test('takes away money from the player buying it', () {
        expect(player.balance, Player.baseBalance);
        property.buyProperty(player);
        expect(player.balance, Player.baseBalance - property.price);
        expect(property.owner, player);
      });

      test("doesn't do anything and returns false if the player doesn't have enough money", () {
        player.balance = 0;
        expect(player.balance, 0);
        expect(property.buyProperty(player), isFalse);
        expect(player.balance, 0);
        expect(property.owner, isNull);
      });
    });

    group('sellProperty', () {
      test('takes away money from the player buying it and gives to the one selling', () {
        property.owner = owner;
        expect(owner.balance, Player.baseBalance);
        expect(player.balance, Player.baseBalance);
        property.sellProperty(player);
        expect(player.balance, Player.baseBalance - property.price);
        expect(owner.balance, Player.baseBalance + property.price);
        expect(property.owner, player);
      });

      test("doesn't do anything and returns false if the player doesn't have enough money", () {
        property.owner = owner;
        player.balance = 0;
        expect(player.balance, 0);
        expect(owner.balance, Player.baseBalance);
        expect(property.sellProperty(player), isFalse);
        expect(player.balance, 0);
        expect(owner.balance, Player.baseBalance);
        expect(property.owner, owner);
      });
    });

    group('payRent', () {
      test('takes from the player and gives to the owner', () {
        // Set to 0 houses for testing base rent
        property.numHouses = 0;

        expect(owner.balance, Player.baseBalance);
        expect(player.balance, Player.baseBalance);
        property.owner = owner;
        property.payRent(player, 1);
        expect(owner.balance, Player.baseBalance + property.rent[property.numHouses]);
        expect(player.balance, Player.baseBalance - property.rent[property.numHouses]);
      });

      void testBalanceFromNumberOfHouses(int numOfHouses) {
        owner.balance = Player.baseBalance;
        player.balance = Player.baseBalance;
        // Set to 0 houses for testing base rent
        property.numHouses = numOfHouses;

        expect(owner.balance, Player.baseBalance);
        expect(player.balance, Player.baseBalance);
        property.owner = owner;
        property.payRent(player, 1);
        expect(owner.balance, Player.baseBalance + property.rent[property.numHouses]);
        expect(player.balance, Player.baseBalance - property.rent[property.numHouses]);
      }

      test('takes the correct amount based on number of houses', () {
        for (int i = 0; i < 5; i++) {
          testBalanceFromNumberOfHouses(i);
        }
      });

      test('takes the correct amount based on the number of houses', () {
        property.isHotel = true;
        testBalanceFromNumberOfHouses(5);
      });
    });

    group('auction', () {
      test('makes the player with the highest bid own the house and pay the bid', () {
        List players = [player..bid = 70, new Player('2', 'Player 2')..bid = 50];
        property.auction(players);

        expect(player.balance, Player.baseBalance - 70);
        expect(property.owner, player);
      });

      test('returns false if the player bids more than they own', () {
        List players = [player..bid = 70..balance = 0, new Player('2', 'Player 2')..bid = 50];
        expect(property.auction(players), isFalse);
      });
    });

    group('mortgage', () {
      setUp(() {
        property.owner = owner;
      });

      test('gives the player half the cost of the property', () {
        expect(owner.balance, Player.baseBalance);
        // Get price before mortgage to compare balance after
        int price = property.price;
        property.mortgage();
        expect(owner.balance, Player.baseBalance + price ~/ 2);
      });

      test('sets the house to mortgaged', () {
        expect(property.isMortgaged, isFalse);
        property.mortgage();
        expect(property.isMortgaged, isTrue);
      });

      group('does nothing and returns false if', () {
        test('there are houses on the property', () {
          expect(property.isMortgaged, isFalse);
          property.numHouses = 1;
          expect(property.mortgage(), isFalse);
          expect(property.isMortgaged, isFalse);
        });

        test('the property is not owned', () {
          expect(property.isMortgaged, isFalse);
          property.owner = null;
          expect(property.mortgage(), isFalse);
          expect(property.isMortgaged, isFalse);
        });

        test('the property is already mortgaged', () {
          expect(property.isMortgaged, isFalse);
          expect(owner.balance, Player.baseBalance);

          // Get price before mortgage to compare balance after
          int price = property.price;
          // Mortgage to become mortgaged
          expect(property.mortgage(), isTrue);
          expect(property.isMortgaged, isTrue);
          expect(owner.balance, Player.baseBalance + price ~/ 2);

          expect(property.mortgage(), isFalse);
          // Still mortgaged and the owner didn't pay again
          expect(property.isMortgaged, isTrue);
          expect(owner.balance, Player.baseBalance + price ~/ 2);
        });

        test('the property has a hotel', () {
          expect(property.isMortgaged, isFalse);
          property.isHotel = true;
          expect(property.mortgage(), isFalse);
          expect(property.isMortgaged, isFalse);
        });
      });
    });

    test('price returns the normal price if not mortgaged', () {
      expect(property.price, 20);
    });

    test('price reutrns the normal price * 1.1 if mortgaged', () {
      property.owner = owner;
      property.mortgage();
      expect(property.price, (20 * 1.1).toInt());
    });

    group('tradeProperty', () {
      test('trades the properties', () {
        property.owner = owner;

        Property property2 = new Property(20, [1, 2, 3, 4, 5], Color.purple);
        property2.owner = player;

        property.tradeProperty(property2);

        expect(property.owner, player);
        expect(property2.owner, owner);
      });

      group('does nothing if', () {
        group('there are houses on', () {
          test('the first property', () {
            property.owner = owner;
            property.numHouses = 1;

            Property property2 = new Property(20, [1, 2, 3, 4, 5], Color.purple);
            property2.owner = player;

            property.tradeProperty(property2);

            expect(property.owner, owner);
            expect(property2.owner,  player);
          });

          test('the second property', () {
            property.owner = owner;

            Property property2 = new Property(20, [1, 2, 3, 4, 5], Color.purple);
            property2.owner = player;
            property2.numHouses = 1;

            property.tradeProperty(property2);

            expect(property.owner, owner);
            expect(property2.owner,  player);
          });
        });

        group('there is a hotel on', () {
          test('the first property', () {
            property.owner = owner;
            property.isHotel = true;

            Property property2 = new Property(20, [1, 2, 3, 4, 5], Color.purple);
            property2.owner = player;

            property.tradeProperty(property2);

            expect(property.owner, owner);
            expect(property2.owner,  player);
          });

          test('the second property', () {
            property.owner = owner;

            Property property2 = new Property(20, [1, 2, 3, 4, 5], Color.purple);
            property2.owner = player;
            property2.isHotel = true;

            property.tradeProperty(property2);

            expect(property.owner, owner);
            expect(property2.owner,  player);
          });
        });
      });
    });

    test('housePrice returns the correct value for the color of the house', () {
      property.color = Color.brown;
      expect(property.housePrice(true), 50);

      property.color = Color.lightBlue;
      expect(property.housePrice(true), 50);

      property.color = Color.purple;
      expect(property.housePrice(true), 50);

      property.color = Color.orange;
      expect(property.housePrice(true), 100);

      property.color = Color.red;
      expect(property.housePrice(true), 100);

      property.color = Color.yellow;
      expect(property.housePrice(true), 150);

      property.color = Color.green;
      expect(property.housePrice(true), 150);

      property.color = Color.darkBlue;
      expect(property.housePrice(true), 200);

      property.color = Color.utility;
      expect(property.housePrice(true), -1);

      property.color = Color.railroad;
      expect(property.housePrice(true), -1);
    });

    group('buyHouse', () {
      setUp(() {
        property.owner = owner;
      });

      test('adds to the number of houses', () {
        expect(property.numHouses, 0);
        property.buyHouse();
        expect(property.numHouses, 1);
      });

      test('takes money from the owner', () {
        expect(owner.balance, Player.baseBalance);
        property.buyHouse();
        expect(owner.balance, Player.baseBalance - property.housePrice(true));
      });

      test('does nothing and returns false if there is a hotel already', () {
        property.isHotel = true;
        expect(property.numHouses, 0);
        expect(property.buyHouse(), isFalse);
        expect(property.isHotel, isTrue);
        expect(property.numHouses, 0);
      });

      test("does nothing and returns false if the owner can't afford the house", () {
        owner.balance = 0;
        expect(property.numHouses, 0);
        expect(property.isHotel, isFalse);
        expect(property.buyHouse(), isFalse);
        expect(property.isHotel, isFalse);
        expect(property.numHouses, 0);
      });

      test('turns into hotel if there are 5 houses', () {
        for (int i = 0; i < 5; i++) {
          expect(property.numHouses, i);
          expect(property.isHotel, isFalse);
          property.buyHouse();
        }

        expect(property.numHouses, 0);
        expect(property.isHotel, isTrue);
      });
    });

    group('sellHouse', () {
      setUp(() {
        property.owner = owner;
      });

      test('subtracts from the number of houses', () {
        property.numHouses = 1;
        expect(property.numHouses, 1);
        property.sellHouse();
        expect(property.numHouses, 0);
      });

      test('gives money from to the owner', () {
        property.numHouses = 1;
        expect(owner.balance, Player.baseBalance);
        property.sellHouse();
        expect(owner.balance, Player.baseBalance + property.housePrice(false));
      });

      test('sells the hotel if the property has a hotel', () {
        property.isHotel = true;
        expect(property.numHouses, 0);
        property.sellHouse();
        expect(property.isHotel, isFalse);
        expect(property.numHouses, 0);
      });
    });

    group('payMortgage', () {
      int ownerBaseBalance;
      setUp(() {
        property.owner = owner;
        property.mortgage();
        ownerBaseBalance = owner.balance;
      });

      group('returns false if', () {
        test('the property is not owned', () {
          property.owner = null;
          expect(property.payMortgage(), isFalse);
        });

        test('the owner does not have enough money', () {
          owner.balance = 0;
          expect(property.payMortgage(), isFalse);
        });

        test('the property is not mortgaged', () {
          // Pay mortgage once to become not mortgaged from setUp
          expect(property.payMortgage(), isTrue);

          expect(property.payMortgage(), isFalse);
        });
      });

      test('takes money from the owner', () {
        expect(owner.balance, ownerBaseBalance);

        // Get the price while still mortgaged
        int price = property.price.toInt();

        expect(property.payMortgage(), isTrue);

        expect(owner.balance, ownerBaseBalance - price);
      });

      test('makes mortgage false', () {
        expect(property.isMortgaged, isTrue);
        property.payMortgage();
        expect(property.isMortgaged, isFalse);
      });
    });
  });
}