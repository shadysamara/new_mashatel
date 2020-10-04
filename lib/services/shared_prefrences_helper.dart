import 'package:mashatel/features/sign_in/models/sp_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  SPHelper._();

  static final SPHelper spHelper = SPHelper._();
  SharedPreferences prefs;

  Future<SharedPreferences> initSharedPreferences() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs;
  }

////////////////////////////////////////////////////////////////////////////////
  ///language
  setLanguage(String lan) async {
    prefs = await spHelper.initSharedPreferences();
    prefs.setString('language', lan);
  }

  Future<String> getLanguage() async {
    prefs = await spHelper.initSharedPreferences();
    String language = prefs.getString('language');
    return language;
  }

//////////////////////////////////////////////////////////////////////////////////
  ///terms and conditions
  Future<bool> showTermAndCondition() async {
    prefs = await spHelper.initSharedPreferences();
    bool showTermCondition = prefs.getBool('showTermCondition');
    return showTermCondition != null ? showTermCondition : true;
  }

  setShowTermAndCondition(bool value) async {
    prefs = await spHelper.initSharedPreferences();
    prefs.setBool('showTermCondition', value);
  }

  /////////////////////////////////////////////////////////////////////////
  ///first time
  Future<bool> checkIfFirstTime() async {
    prefs = await spHelper.initSharedPreferences();
    bool isFirstTime = prefs.getBool('isFirstTime');
    bool result;
    if (isFirstTime == null) {
      setIsNotFirstTime();
      return true;
    } else {
      return false;
    }
  }

  setIsNotFirstTime() async {
    prefs = await spHelper.initSharedPreferences();
    prefs.setBool('isFirstTime', false);
  }

//////////////////////////////////////////////////////////////////////////
  ///security
  Future<SpUser> getUserCredintial() async {
    prefs = await spHelper.initSharedPreferences();

    String userId = prefs.getString('userId');
    bool isAdmin = prefs.getBool('isAdmin');
    bool isCustomer = prefs.getBool('isCustomer');
    bool isMarket = prefs.getBool('isMarket');
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

  Future<SpUser> setUserCredintials(
      {String userId, bool isAdmin, bool isMarket, bool isCustomer}) async {
    prefs = await spHelper.initSharedPreferences();
    prefs.setString('userId', userId);
    prefs.setBool('isAdmin', isAdmin);
    prefs.setBool('isMarket', isMarket);
    prefs.setBool('isCustomer', isCustomer);
    prefs.setBool('isLogged', true);
    Map<String, dynamic> map = {
      'userId': userId,
      'isAdmin': isAdmin,
      'isCustomer': isCustomer,
      'isMarket': isMarket
    };
    SpUser spUser = SpUser.fromSpMap(map);
    return spUser;
  }

  clearUserCredintials() async {
    prefs = await spHelper.initSharedPreferences();
    prefs.remove('userId');
    prefs.remove('isAdmin');
    prefs.remove('isMarket');
    prefs.remove('isCustomer');
    prefs.remove('isLogged');
  }
}
