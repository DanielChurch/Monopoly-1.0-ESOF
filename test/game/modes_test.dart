import 'package:monopoly/game/modes.dart';
import 'package:test/test.dart';

void main() {
  group('Modes', () {
    test('modes are false by default', () {
      Modes.uri = new Uri();
      expect(Modes.quickroll, isFalse);
      expect(Modes.skiproster, isFalse);
    });

    test('quickroll is true when a query param', () {
      Modes.uri = new Uri(queryParameters: {'skiproster': ''});
      expect(Modes.skiproster, isTrue);
    });

    test('skiproster is true when a query param', () {
      Modes.uri = new Uri(queryParameters: {'quickroll': ''});
      expect(Modes.quickroll, isTrue);
    });

    test('all modes are true with the given query params', () {
      Modes.uri = new Uri(queryParameters: {'quickroll': '', 'skiproster': ''});
      expect(Modes.quickroll, isTrue);
      expect(Modes.quickroll, isTrue);
    });
  });
}