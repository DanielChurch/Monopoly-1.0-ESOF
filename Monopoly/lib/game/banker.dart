import 'package:meta/meta.dart';

import 'player.dart';
import 'property.dart';
import 'tile.dart';

class Banker {

  int _housesRemaining;

  List<Player> _players;

  List<Property> _deeds;
  List<Tile> _board;
  DateTime _endTime;

  Banker() {}
  
  List<Player> get players => _players;

  @visibleForTesting
  set endTime(DateTime endTime) => _endTime = endTime;

  bool sellPropertyToPlayer(Property property) {}

  bool isWithinMaxTime() => new DateTime.now().millisecondsSinceEpoch < _endTime.millisecondsSinceEpoch;
  Player declareWinner() {}
  bool _updateProperty(Property property) {}
  void _updateLocation(Player player) {}

}