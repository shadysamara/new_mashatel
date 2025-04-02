import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/modles/product_model.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/customers/ui/pages/product_details/product_Details_main.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';

class DynamicLinkService {
  AppGet appGet = Get.find();
  static Future<String> generateDynamicLink(String value) async {
    String url =
        '''https://opaavenuse.page.link?amv=1&apn=com.opaavenuse.opaavenuse&ibi=com.shady.opaavenuseUI&imv=1&isi=123456789&link=https%3A%2F%2Fopaavenuse.page.link.com%2F%3Fid%3D$value''';
    return url;
  }

  Future<Uri> createDynamicLink({String url}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://mashatel.page.link',
      link: Uri.parse('https://mashatel.page.link.com/?id=$url'),
      androidParameters: AndroidParameters(
        packageName: 'com.accsit.mashatel',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.accsit.mashatel',
        minimumVersion: '1',
        appStoreId: '1541543746',
      ),
    );
    var dynamicUrl = await parameters.buildUrl();

    return dynamicUrl;
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('id')) {
          String id = deepLink.queryParameters['id'];
          ProductModel productModel =
              await MashatelClient.mashatelClient.getProductById(id);
          AppUser appUser = await MashatelClient.mashatelClient
              .getMarketFromFirebase(productModel.marketId);
          appGet.isFromDynamic = true;
          Get.to(ProductDetails(productModel, appUser, true));
        }
      }

      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        if (dynamicLink != null) {
          if (dynamicLink.link.queryParameters.containsKey('id')) {
            String id = dynamicLink.link.queryParameters['id'];

            ProductModel productModel =
                await MashatelClient.mashatelClient.getProductById(id);
            AppUser appUser = await MashatelClient.mashatelClient
                .getMarketFromFirebase(productModel.marketId);
            appGet.isFromDynamic = true;
            Get.to(ProductDetails(productModel, appUser, true));
          }
        }
      });
    } catch (e) {
      Logger().e(e.toString());
    }
  }
}
