import 'dart:io';

import 'package:mashatel/features/customers/modles/product_model.dart';

class AppUser {
  String? userName;
  String? phoneNumber;
  String? email;
  String? password;
  String? companyName;
  File? marketLogo;
  String? imagePath;
  double? lat;
  double? lon;
  String? comapnyActivity;
  bool? isAdmin;
  bool? isMarket;
  bool? isCustomer;
  String? userId;

  AppUser(
      {this.email,
      this.phoneNumber,
      this.userName,
      this.password,
      this.comapnyActivity,
      this.companyName,
      this.imagePath,
      this.marketLogo,
      this.lat,
      this.lon,
      this.isAdmin,
      this.isCustomer,
      this.userId,
      this.isMarket});
  AppUser.fromCustomerJson(Map map) {
    this.userName = map['userName'];
    this.phoneNumber = map['phoneNumber'];
    this.email = map['email'];
    this.isAdmin = map['isAdmin'];
    this.isMarket = map['isMarket'];
    this.isCustomer = map['isCustomer'];
    this.userId = map['userId'];
  }
  AppUser.fromMarketJson(Map map) {
    this.companyName = map['companyName'];
    this.comapnyActivity = map['companyActivity'];
    this.email = map['email'];
    this.phoneNumber = map['phoneNumber'];
    this.userName = map['userName'];
    this.lat = map['latitude'];
    this.lon = map['longitude'];
    this.imagePath = map['imagePath'];
    this.isAdmin = map['isAdmin'];
    this.isMarket = map['isMarket'];
    this.isCustomer = map['isCustomer'];
    this.userId = map['userId'];
  }

  Map<String, dynamic> toCustomerJson() {
    return {
      'userName': this.userName,
      'phoneNumber': this.phoneNumber,
      'email': this.email,
      'isAdmin': this.isAdmin,
      'isMarket': this.isMarket,
      'isCustomer': this.isCustomer
    };
  }

  Map<String, dynamic> toMarketJson() {
    return {
      'companyName': this.companyName,
      'companyActivity': this.comapnyActivity,
      'email': this.email,
      'imageFile': this.marketLogo,
      'phoneNumber': this.phoneNumber,
      'userName': this.userName,
      'latitude': this.lat,
      'longitude': this.lon,
      'isAdmin': this.isAdmin,
      'isMarket': this.isMarket,
      'isCustomer': this.isCustomer
    };
  }
}
