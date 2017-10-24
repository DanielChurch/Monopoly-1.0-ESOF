class Player {

  int _location;
  int _balance;

  bool _isInJail;

  int get balance => _balance;
  int get location => _location;

  void payRent(int amount) => _balance -= amount;

}