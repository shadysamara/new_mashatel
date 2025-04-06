import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mashatel/features/customers/modles/about.dart';
import 'package:mashatel/features/customers/modles/product_model.dart';
import 'package:mashatel/features/customers/modles/terms.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/customers/ui/pages/main_page.dart';
import 'package:mashatel/features/customers/ui/pages/market_page.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';
import 'package:mashatel/services/auth.dart';

import 'package:mashatel/services/shared_prefrences_helper.dart';
import 'package:mashatel/welcome_page.dart';
import 'features/customers/blocs/app_get.dart';
import 'features/sign_in/models/sp_user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin<SplashScreen> {
  final AppGet appGet = Get.find();
  final SignInGetx signInGetx = Get.put(SignInGetx());
  SpUser? spUser;
  AppUser? appUser;
  TermsModel? terms;
  AboutAppModel? aboutApp;

  Future<void> getAppUser() async {
    appUser = await RegistrationClient.registrationIntance
        .getMarketFromFirestore(spUser?.userId);
    if (spUser?.isMarket == true) {
      await appGet.getMarketProducts(spUser?.userId);
    }
    if (appUser != null) {
      appGet.setAppUser(appUser!);
    }
  }

  Future<void> getTerms() async {
    terms = await MashatelClient.mashatelClient.getTermsAndConditions();
    if (terms != null) {
      appGet.setTermsModel(terms!);
    }
  }

  Future<void> getAboutApp() async {
    aboutApp = await MashatelClient.mashatelClient.getAboutApp();
    if (aboutApp != null) {
      appGet.setAboutModel(aboutApp!);
    }
  }

  Future<void> getChats(String myId) async {
    final List<Map<String, dynamic>>? allChats =
        await MashatelClient.mashatelClient.getAllChats(myId);
    if (allChats != null) {
      appGet.allChats.value = allChats;
    }
  }

  Future<void> getAds() async {
    await MashatelClient.mashatelClient.getAllAdvertisments();
  }

  Future<List<ProductModel>?> getBannedUsers() async {
    return await MashatelClient.mashatelClient.getReportedProducts();
  }

  Future<void> getAllVariables() async {
    spUser = await SPHelper.spHelper.getUserCredintial();
    if (spUser != null) {
      await getAppUser();
      await getChats(spUser!.userId!);
      if (spUser!.isAdmin == true) {
        final List<ProductModel>? bannedProducts = await getBannedUsers();
        if (bannedProducts != null) {
          appGet.setBannedProducts(bannedProducts);
        }
      }
    }

    await getAds();
    await getTerms();
    await getAboutApp();
    // await FireMessaging.firebaseMessaging.initFirebaseMessaging(context);
    // await FireMessaging.firebaseMessaging.subscribeTopic();
  }

  @override
  void initState() {
    super.initState();
    getAllVariables();
    Timer(const Duration(seconds: 3), () {
      if (!appGet.isFromDynamic) {
        if (spUser != null) {
          if (spUser?.isCustomer == true) {
            signInGetx.usertype.value = UserType.customer;
            Get.off(() => MainPage());
          } else if (spUser?.isMarket == true) {
            signInGetx.usertype.value = UserType.market;
            appGet.marketId.value = spUser!.userId!;
            Get.off(() => MarketPage(appUser: appUser));
          } else if (spUser?.isAdmin == true) {
            signInGetx.usertype.value = UserType.admin;
            Get.off(() => MainPage());
          }
        } else {
          Get.off(() => WelcomePage());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      body: Container(
        width: MediaQuery.of(context).size.width,
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/logo.png"),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    await appGet.getAllMarkets();
  }
}
