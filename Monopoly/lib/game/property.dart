class Property {

  int _rent;
  bool _isMortgaged = false;

  bool isOwned = false;
  int price;
  String color;
  int numHouses = 0;
  int numHotels = 0;

  Property(int this.price, int this._rent, String this.color);

  bool get isMortgaged => _isMortgaged;
  int get rent => _rent;

}