import 'package:meta/meta.dart';

import 'player.dart';
import 'property.dart';
import 'tile.dart';
import 'tile_type.dart';

class Banker {

  int _housesRemaining;

  List<Player> _players;

  List<Property> _deeds;
  
  List<Tile> _board = [
    new Tile(TileType.go),
    new Tile(TileType.property),
    new Tile(TileType.freeParking),
    new Tile(TileType.property),
    new Tile(TileType.incomeTax),
    new Tile(TileType.railroad),
    new Tile(TileType.property),
    new Tile(TileType.freeParking),
    new Tile(TileType.property),
    new Tile(TileType.property),
    new Tile(TileType.jail),
    new Tile(TileType.property),
    new Tile(TileType.utility),
    new Tile(TileType.property),
    new Tile(TileType.property),
    new Tile(TileType.railroad),
    new Tile(TileType.property),
    new Tile(TileType.freeParking),
    new Tile(TileType.property),
    new Tile(TileType.property),
    new Tile(TileType.freeParking),
    new Tile(TileType.property),
    new Tile(TileType.freeParking),
    new Tile(TileType.property),
    new Tile(TileType.property),
    new Tile(TileType.railroad),
    new Tile(TileType.property),
    new Tile(TileType.property),
    new Tile(TileType.utility),
    new Tile(TileType.property),
    new Tile(TileType.goToJail),
    new Tile(TileType.property),
    new Tile(TileType.property),
    new Tile(TileType.freeParking),
    new Tile(TileType.property),
    new Tile(TileType.railroad),
    new Tile(TileType.freeParking),
    new Tile(TileType.property),
    new Tile(TileType.luxuryTax),
    new Tile(TileType.property)
  ];
  
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