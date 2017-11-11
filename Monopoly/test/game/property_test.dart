
import 'package:monopoly/game/property.dart';
import 'package:test/test.dart';

void main() {
  group('Property', () {
    Property property;

    setUp(() {
      property = new Property(20, 30, [], Color.railroad);
    });

    test('constructs properly', () {
      expect(Color.railroad, property.color);
      expect(20, property.rent);
      expect(30, property.price);
    });
  });
}