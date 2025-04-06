import 'dart:developer';

import 'package:get/get.dart';
import 'package:mashatel/features/sign_in/models/sp_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  static final SPHelper spHelper = SPHelper();
  initSharedPrefrences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(sharedPreferences, permanent: true);
  }

////////////////////////////////////////////////////////////////////////////////
  ///language
  setLanguage(String lan) async {
    Get.find<SharedPreferences>().setString('language', lan);
  }

  String getLanguage() {
    String language =
        Get.find<SharedPreferences>().getString('language') ?? 'ar';
    log("the saved language is $language");
    return language;
  }

//////////////////////////////////////////////////////////////////////////////////
  ///terms and conditions
  bool showTermAndCondition() {
    bool? showTermCondition =
        Get.find<SharedPreferences>().getBool('showTermCondition');
    return showTermCondition != null ? showTermCondition : true;
  }

  setShowTermAndCondition(bool value) {
    Get.find<SharedPreferences>().setBool('showTermCondition', value);
  }

  /////////////////////////////////////////////////////////////////////////
  ///first time
  bool checkIfFirstTime() {
    bool? isFirstTime = Get.find<SharedPreferences>().getBool('isFirstTime');
    if (isFirstTime == null) {
      setIsNotFirstTime();
      return true;
    } else {
      return false;
    }
  }

  setIsNotFirstTime() {
    Get.find<SharedPreferences>().setBool('isFirstTime', false);
  }

//////////////////////////////////////////////////////////////////////////
  ///security
  SpUser? getUserCredintial() {
    String? userId = Get.find<SharedPreferences>().getString('userId');
    bool isAdmin = Get.find<SharedPreferences>().getBool('isAdmin') ?? false;
    bool isCustomer =
        Get.find<SharedPreferences>().getBool('isCustomer') ?? false;
    bool isMarket = Get.find<SharedPreferences>().getBool('isMarket') ?? false;
    Map<String, dynamic> map = {
      'userId': userId,
      'isAdmin': isAdmin,
      'isCustomer': isCustomer,
      'isMarket': isMarket
    };
    SpUser spUser = SpUser.fromSpMap(map);
    if (userId != null) {
      return spUser;
    } else {
      return null;
    }
  }

  SpUser setUserCredintials(
      {required String userId,
      bool isAdmin = false,
      bool isMarket = false,
      bool isCustomer = false}) {
    Get.find<SharedPreferences>().setString('userId', userId);
    Get.find<SharedPreferences>().setBool('isAdmin', isAdmin);
    Get.find<SharedPreferences>().setBool('isMarket', isMarket);
    Get.find<SharedPreferences>().setBool('isCustomer', isCustomer);
    Get.find<SharedPreferences>().setBool('isLogged', true);
    Map<String, dynamic> map = {
      'userId': userId,
      'isAdmin': isAdmin,
      'isCustomer': isCustomer,
      'isMarket': isMarket
    };
    SpUser spUser = SpUser.fromSpMap(map);
    return spUser;
  }

  clearUserCredintials() {
    Get.find<SharedPreferences>().remove('userId');
    Get.find<SharedPreferences>().remove('isAdmin');
    Get.find<SharedPreferences>().remove('isMarket');
    Get.find<SharedPreferences>().remove('isCustomer');
    Get.find<SharedPreferences>().remove('isLogged');
  }
}
