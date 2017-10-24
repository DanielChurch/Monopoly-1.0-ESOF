import 'player.dart';
import 'property.dart';
import 'square.dart';

class Banker {

  int _housesRemaining;

  List<Player> _players;

  List<Property> _deeds;
  List<Square> _board;
  DateTime _endTime;

  Banker() {}
  
  List<Player> get players => _players;

  bool sellPropertyToPlayer(Property property) {}

  bool _isWithinMaxTime() => new DateTime.now().millisecondsSinceEpoch < _endTime.millisecondsSinceEpoch;
  Player declareWinner() {}
  bool _updateProperty(Property property) {}
  void _updateLocation(Player player) {}

}