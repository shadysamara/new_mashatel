import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:mashatel/features/customers/modles/category.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';
import 'package:mashatel/utils/ProgressDialogUtils.dart';

class SignInGetx {
  var fileName = ('market_logo'.tr).obs;
  var isBusy = false.obs;
  var usertype = UserType.unDefined.obs;

  Category? category;
  var cat = Category().obs;
  setCategory(Category category) {}

  File? file;
  String? companyName;
  String? imagePath;
  var pr = ProgressDialogUtils(Get.context!);
  ////////////////////////////////////////////////////////////////

  setUserType(UserType usertype) {
    this.usertype.value = usertype;
  }

  clearUserType() {
    this.usertype.value = UserType.unDefined;
  }
  ////////////////////////////////////////////////////////////////
  ///position functions

  var position = Position(
    latitude: 24.4539,
    longitude: 54.3773,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    altitudeAccuracy: 0.0,
    heading: 0.0,
    headingAccuracy: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  ).obs;
  var poitinAsString = ''.obs;
  var positionIsMarkes = false.obs;

  Future<Position> setCurrentLocation() async {
    this.position.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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
      if (file == null) {
        Get.defaultDialog(
          middleText: 'please_select_image'.tr,
          title: 'alert',
          confirm: CupertinoButton(
              child: Text('Ok'),
              onPressed: () {
                print('ok');
                Get.back();
              }),
        );
        return;
      }
      if (companyName == null || companyName!.isEmpty) {
        Get.defaultDialog(
          middleText: 'please_enter_company_name'.tr,
          title: 'alert',
          confirm: CupertinoButton(
              child: Text('Ok'),
              onPressed: () {
                print('ok');
                Get.back();
              }),
        );
        return;
      }

      imagePath = await RegistrationClient.registrationIntance
          .addMarketImage(file!, companyName!);
    } catch (error) {
      Get.defaultDialog(
        middleText: error.toString(),
        title: 'alert'.tr,
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
