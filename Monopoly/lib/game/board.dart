import 'color.dart';
import 'tile.dart';
import 'tile_type.dart';
import 'property.dart';

class Board {

  static final List<Tile> _tiles = [
    new Tile(type: TileType.go),
    new Tile(property: new Property(60, [2, 10, 30, 90, 160, 250], Color.brown)),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(60, [4, 20, 60, 180, 320, 450], Color.brown)),
    new Tile(type: TileType.freeParking),
    // Railroad is: $25 if owned, $50 for 2, $100 if three, 200 if all owned
    new Tile(property: new Property(200, [25, 50, 100, 200], Color.railroad)),
    new Tile(property: new Property(100, [6, 30, 90, 270, 400, 550], Color.lightBlue)),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(100, [6, 30, 90, 270, 400, 550], Color.lightBlue)),
    new Tile(property: new Property(120, [8, 40, 100, 300, 450, 600], Color.lightBlue)),
    new Tile(type: TileType.jail),
    new Tile(property: new Property(140, [10, 50, 150, 450, 625, 750], Color.purple)),
    // Utility is 4 x dice roll and 10 x dice roll if both utilities are owned
    new Tile(property: new Property(150, [4, 10], Color.utility)),
    new Tile(property: new Property(140, [10, 50, 150, 450, 625, 750], Color.purple)),
    new Tile(property: new Property(160, [12, 60, 180, 500, 700, 900], Color.purple)),
    new Tile(property: new Property(200, [25, 50, 100, 200], Color.railroad)),
    new Tile(property: new Property(180, [14, 70, 200, 550, 750, 950], Color.orange)),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(180, [14, 70, 200, 550, 750, 950], Color.orange)),
    new Tile(property: new Property(200, [16, 80, 220, 600, 800, 1000], Color.orange)),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(220, [16, 80, 220, 600, 800, 1000], Color.red)),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(220, [18, 90, 250, 700, 875, 1050], Color.red)),
    new Tile(property: new Property(240, [20, 100, 300, 750, 925, 1100], Color.red)),
    new Tile(property: new Property(200, [25, 50, 100, 200], Color.railroad)),
    new Tile(property: new Property(260, [22, 110, 330, 800, 975, 1150], Color.yellow)),
    new Tile(property: new Property(260, [22, 110, 330, 800, 975, 1150], Color.yellow)),
    new Tile(property: new Property(150, [4, 10], Color.utility)),
    new Tile(property: new Property(280, [24, 120, 360, 850, 1025, 1200], Color.yellow)),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(300, [26, 130, 390, 900, 1100, 1275], Color.green)),
    new Tile(property: new Property(300, [26, 130, 390, 900, 1100, 1275], Color.green)),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(320, [28, 150, 450, 1000, 1200, 1400], Color.green)),
    new Tile(property: new Property(200, [25, 50, 100, 200], Color.railroad)),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(350, [35, 175, 500, 1100, 1300, 1500], Color.darkBlue)),
    new Tile(type: TileType.freeParking),
    new Tile(property: new Property(400, [50, 200, 600, 1400, 1700, 2000], Color.darkBlue))
  ];

  static get tiles => _tiles;

}