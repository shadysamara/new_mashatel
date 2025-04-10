import 'package:mashatel/features/customers/modles/category.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

class ProductModel {
  String? nameAr;
  String? nameEn;
  String? descAr;
  String? descEn;
  double? price;
  List<Asset>? assetImages;
  List<String>? imagesUrls;
  bool? isInnerMessages;
  bool? isWithoutPhoneNumber;
  String? productId;
  String? marketId;
  int? bannedUsers;
  bool? isBanned;
  Category? category;
  ProductModel(
      {this.descAr,
      this.descEn,
      this.assetImages,
      this.imagesUrls,
      this.isInnerMessages,
      this.isWithoutPhoneNumber,
      this.nameAr,
      this.nameEn,
      this.price,
      this.productId,
      this.isBanned,
      this.marketId,
      required this.category});
  ProductModel.fromMap(Map map) {
    this.nameAr = map['nameAr'];
    this.nameEn = map['nameEn'];
    this.descAr = map['descAr'];
    this.descEn = map['descEn'];
    this.imagesUrls = map['imagesUrls'].cast<String>();
    this.price = map['price'];
    this.isInnerMessages = map['isInnerMessages'];
    this.isWithoutPhoneNumber = map['isWithoutPhoneNumber'];
    this.productId = map['productId'];
    this.marketId = map['marketId'];
    this.isBanned = map['isBanned'];
    this.category =
        map['category'] != null ? Category.fromMap(map['category']) : null;
  }
  toJson() {
    return {
      'nameAr': this.nameAr,
      'nameEn': this.nameEn,
      'descAr': this.descAr,
      'descEn': this.descEn,
      'imagesUrls': this.imagesUrls,
      'isInnerMessages': this.isInnerMessages,
      'isWithoutPhoneNumber': this.isWithoutPhoneNumber,
      'price': this.price,
      'marketId': this.marketId,
      'isBanned': false,
      "category": this.category != null ? this.category?.toJson() : null,
    };
  }
}
