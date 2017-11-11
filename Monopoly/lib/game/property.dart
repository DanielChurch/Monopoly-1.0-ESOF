
enum Color {
  brown,
  lightBlue,
  purple,
  orange,
  red,
  yellow,
  green,
  darkBlue,
  utility,
  railroad,
}

class Property {

  List _rent;


  bool _isMortgaged = false;

  bool isOwned = false;
  int price;
  int mortgage;
  Color color;

  int numHouses = 0;
  int numHotels = 0;

  Property(int this.price, int this.mortgage, List this._rent, Color this.color);

  bool get isMortgaged => _isMortgaged;
  List get rent => _rent;

}