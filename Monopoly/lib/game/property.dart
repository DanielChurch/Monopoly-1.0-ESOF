class Property {

  int _rent;
  bool _isMortgaged = false;

  bool isOwned = false;
  int price;
  String color;
  int numHouses = 0;
  int numHotels = 0;

  bool get isMortgaged => _isMortgaged;
  int get rent => _rent;

  Property(int this._rent, int this.price, String this.color);
}