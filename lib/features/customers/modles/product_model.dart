import 'dart:io';

import 'package:multi_image_picker/multi_image_picker.dart';

class ProductModel {
  String nameAr;
  String nameEn;
  String descAr;
  String descEn;
  double price;
  List<Asset> assetImages;
  List<String> imagesUrls;
  bool isInnerMessages;
  bool isWithoutPhoneNumber;
  ProductModel(
      {this.descAr,
      this.descEn,
      this.assetImages,
      this.imagesUrls,
      this.isInnerMessages,
      this.isWithoutPhoneNumber,
      this.nameAr,
      this.nameEn,
      this.price});
  ProductModel.fromMap(Map map) {
    this.nameAr = map['nameAr'];
    this.nameEn = map['nameEn'];
    this.descAr = map['descAr'];
    this.descEn = map['descEn'];
    this.imagesUrls = map['imagesUrls'];
    this.price = map['price'];
    this.isInnerMessages = map['isInnerMessages'];
    this.isWithoutPhoneNumber = map['isWithoutPhoneNumber'];
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
    };
  }
}
