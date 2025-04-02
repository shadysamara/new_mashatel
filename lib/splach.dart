import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mashatel/features/customers/modles/about.dart';
import 'package:mashatel/features/customers/modles/product_model.dart';
import 'package:mashatel/features/customers/modles/terms.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/reported_products.dart';
import 'package:mashatel/features/customers/ui/pages/main_page.dart';
import 'package:mashatel/features/customers/ui/pages/market_page.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';
import 'package:mashatel/features/sign_in/ui/pages/login_page_test.dart';
import 'package:mashatel/services/fcm.dart';
import 'package:mashatel/services/shared_prefrences_helper.dart';
import 'package:mashatel/welcome_page.dart';

import 'features/customers/blocs/app_get.dart';
import 'features/sign_in/models/sp_user.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin<SplashScreen> {
  AppGet appGet = Get.find();
  SignInGetx signInGetx = Get.put(SignInGetx());
  SpUser? spUser;
  AppUser? appUser;
  TermsModel? terms;
  AboutAppModel? aboutApp;

  getAppUser() async {
    appUser = await RegistrationClient.registrationIntance
        .getMarketFromFirestore(spUser?.userId);
    if (spUser?.isMarket == true) {
      appGet.getMarketProducts(spUser?.userId);
    }
    appGet.setAppUser(appUser);
  }

  getTerms() async {
    terms = await MashatelClient.mashatelClient.getTermsAndConditions();
    appGet.setTermsModel(terms);
  }

  getAboutApp() async {
    aboutApp = await MashatelClient.mashatelClient.getAboutApp();
    appGet.setAboutModel(aboutApp);
  }

  getChats(String myId) async {
    List<Map<String, dynamic>> allChats =
        await MashatelClient.mashatelClient.getAllChats(myId);

    appGet.allChats.value = allChats;
  }

  getAds() async {
    MashatelClient.mashatelClient.getAllAdvertisments();
  }

  Future<List<ProductModel>> getBannedUsers() async {
    List<ProductModel> products =
        await MashatelClient.mashatelClient.getReportedProducts();

    return products;
  }

  getAllVariables() async {
    spUser = await SPHelper.spHelper.getUserCredintial();
    if (spUser != null) {
      getAppUser();
      getChats(spUser.userId);
      if (spUser.isAdmin) {
        getBannedUsers();
      }
    }

    getAds();
    getTerms();
    getAboutApp();
    FireMessaging.firebaseMessaging.initFirebaseMessaging(context);
    FireMessaging.firebaseMessaging.subscribeTopic();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllVariables();
    Timer(Duration(seconds: 3), () async {
      if (!appGet.isFromDynamic) {
        if (spUser != null) {
          if (spUser.isCustomer) {
            signInGetx.usertype.value = userType.customer;
            Get.off(MainPage());
          }
          if (spUser.isMarket) {
            signInGetx.usertype.value = userType.market;
            appGet.marketId.value = spUser.userId;

            Get.off(MarketPage(appUser));
          }
          if (spUser.isAdmin) {
            signInGetx.usertype.value = userType.admin;
            Get.off(MainPage());
          }
        } else {
          Get.off(WelcomePage());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f3f3),
      body: Container(
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/logo.png"),
        )),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    appGet.getAllCategories();
  }
}
