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
        expect(player.balance, 1300);
        property.buyProperty(player);
        expect(player.balance, 1300 - property.price);
        expect(property.owner, player);
      });

      test("doesn't do anything if the player doesn't have enough money", () {
        player.balance = 0;
        expect(player.balance, 0);
        property.buyProperty(player);
        expect(player.balance, 0);
        expect(property.owner, isNull);
      });
    });

    group('payRent', () {
      test('takes from the player and gives to the owner', () {
        // Set to 0 houses for testing base rent
        property.numHouses = 0;

        expect(owner.balance, 1300);
        expect(player.balance, 1300);
        property.owner = owner;
        property.payRent(player, 1);
        expect(owner.balance, 1300 + property.rent[property.numHouses]);
        expect(player.balance, 1300 - property.rent[property.numHouses]);
      });

      void testBalanceFromNumberOfHouses(int numOfHouses) {
        owner.balance = 1300;
        player.balance = 1300;
        // Set to 0 houses for testing base rent
        property.numHouses = numOfHouses;

        expect(owner.balance, 1300);
        expect(player.balance, 1300);
        property.owner = owner;
        property.payRent(player, 1);
        expect(owner.balance, 1300 + property.rent[property.numHouses]);
        expect(player.balance, 1300 - property.rent[property.numHouses]);
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
  });
}