// subCatId == market id
class Product {
  String nameAr;
  String nameEn;
  String descAr;
  String descEn;
  double price;
  String imageUrl;
  String productId;
  String marketId;
  Product(
      {this.descAr,
      this.descEn,
      this.imageUrl,
      this.nameAr,
      this.nameEn,
      this.price,
      this.productId,
      this.marketId});

  Product.fromMap(Map map) {
    this.nameAr = map['nameAr'];
    this.nameEn = map['nameEn'];
    this.descAr = map['descAr'];
    this.descEn = map['descEn'];
    this.imageUrl = map['imageUrl'];
    this.price = map['price'];
    this.marketId = map['marketId'];
    this.productId = map['productId'];
  }
  Map<String, dynamic> toJson() {
    return {
      'nameAr': this.nameAr,
      'nameEn': this.nameEn,
      'descAr': this.descAr,
      'descEn': this.descEn,
      'imageUrl': this.imageUrl,
      'price': this.price,
      'marketId': this.marketId,
    };
  }
}
