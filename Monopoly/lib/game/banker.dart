import 'player.dart';
import 'property.dart';
import 'square.dart';

class Banker {

  Banker() {}

  int _housesRemaining;

  List<Property> _deeds;
  List<Square> _board;
  int _maxTime;

  bool sellPropertyToPlayer(Property property) {}

  bool _isWithinMaxTime() {}
  Player declareWinner() {}
  bool _updateProperty(Property property) {}
  void _updateLocation(Player player) {}

}