import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/market_page.dart';
import 'package:mashatel/features/customers/ui/widgets/market_item_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/widgets/custom_appbar.dart';
import 'package:mashatel/widgets/custom_drawer.dart';

class MarketsPage extends StatelessWidget {
  AppGet appGet = Get.put(AppGet());
  SignInGetx signInGetx = Get.put(SignInGetx());
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: BaseAppbar('markets'),
      drawer: AppSettings(appGet.appUser.value),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Obx(() {
          return ListView.builder(
            itemCount: appGet.markets.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  appGet.getMarketProducts(appGet.markets[index].userId);

                  Get.to(MarketPage(appGet.markets[index]));
                },
                child: MarketWidget(
                  appUser: appGet.markets[index],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
