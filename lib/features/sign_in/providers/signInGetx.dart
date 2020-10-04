import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:get/get.dart';
import 'package:mashatel/features/customers/modles/category.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';
import 'package:mashatel/utils/ProgressDialogUtils.dart';

class SignInGetx {
  var fileName = translator.translate('market_logo').obs;
  var isBusy = false.obs;
  var usertype = userType.unDefined.obs;

  Category category;
  var cat = Category().obs;
  setCategory(Category category) {}

  File file;
  String companyName;
  String imagePath;
  var pr = ProgressDialogUtils.createProgressDialog(Get.context);
  ////////////////////////////////////////////////////////////////

  setUserType(userType usertype) {
    this.usertype.value = usertype;
  }

  clearUserType() {
    this.usertype.value = userType.unDefined;
  }
  ////////////////////////////////////////////////////////////////
  ///position functions

  var position = Position(latitude: 24.4539, longitude: 54.3773).obs;
  var poitinAsString = ''.obs;
  var positionIsMarkes = false.obs;

  Future<Position> setCurrentLocation() async {
    this.position.value =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setPositionString(position.value.latitude, position.value.longitude);
    return position.value;
  }

  setPositionString(double latitude, double longitude) {
    this.poitinAsString.value =
        '${latitude.toStringAsFixed(3)} - ${longitude.toStringAsFixed(3)}';
  }

  setPositionValue(Position position) {
    this.position.value = position;
    setPositionString(position.latitude, position.longitude);
  }

///////////////////////////////////////////////////////////////////
  addLogoImageToCloude() async {
    try {
      imagePath = await RegistrationClient.registrationIntance
          .addMarketImage(file, companyName);
    } catch (error) {
      Get.defaultDialog(
        middleText: error,
        title: translator.translate('alert'),
        confirm: CupertinoButton(
            child: Text('Ok'),
            onPressed: () {
              print('ok');
              Get.back();
            }),
      );
    }
  }
}
