import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/market_page.dart';
import 'package:mashatel/features/customers/ui/widgets/advertisment_widget.dart';
import 'package:mashatel/features/customers/ui/widgets/market_item_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/widgets/custom_appbar.dart';
import 'package:mashatel/widgets/custom_drawer.dart';
import 'dart:math';

class MarketsPage extends StatelessWidget {
  AppGet appGet = Get.put(AppGet());
  SignInGetx signInGetx = Get.put(SignInGetx());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        appGet.resetMarkets();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: BaseAppbar('markets'),
        endDrawer: AppSettings(
          appGet.appUser.value,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Obx(() {
            return ListView.builder(
              itemCount: appGet.markets.length,
              itemBuilder: (context, index) {
                return index % 3 == 0
                    ? Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: GestureDetector(
                              onTap: () {
                                appGet.getMarketProducts(
                                    appGet.markets[index].userId);

                                Get.to(MarketPage(
                                  appUser: appGet.markets[index],
                                ));
                              },
                              child: MarketWidget(
                                appUser: appGet.markets[index],
                              ),
                            ),
                          ),
                          appGet.advertisments.length > 0
                              ? AdvertismentWidget(
                                  appGet.advertisments[Random()
                                      .nextInt(appGet.advertisments.length)],
                                  10)
                              : Container(),
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: GestureDetector(
                          onTap: () {
                            appGet.getMarketProducts(
                                appGet.markets[index].userId);

                            Get.to(MarketPage(appUser: appGet.markets[index]));
                          },
                          child: MarketWidget(
                            appUser: appGet.markets[index],
                          ),
                        ),
                      );
              },
            );
          }),
        ),
      ),
    );
  }
}
