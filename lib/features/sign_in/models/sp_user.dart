class SpUser {
  String userId;
  bool isAdmin;
  bool isCustomer;
  bool isMarket;
  SpUser({this.isAdmin, this.isCustomer, this.isMarket, this.userId});
  SpUser.fromSpMap(Map map) {
    this.userId = map['userId'];
    this.isAdmin = map['isAdmin'];
    this.isCustomer = map['isCustomer'];
    this.isMarket = map['isMarket'];
  }
}
