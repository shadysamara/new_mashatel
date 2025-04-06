import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/market_page.dart';
import 'package:mashatel/features/customers/ui/pages/markets_page.dart';
import 'package:mashatel/features/customers/ui/widgets/main_category_widget.dart';
import 'package:mashatel/features/customers/ui/widgets/market_item_widget.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/widgets/custom_appbar.dart';
import 'package:mashatel/widgets/custom_drawer.dart';
import 'package:mashatel/widgets/slider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  AppGet appGet = Get.put(AppGet());
  SignInGetx signInGetx = Get.put(SignInGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar('markets'),
      endDrawer: AppSettings(appGet.appUser.value),
      body: Container(
        child: Column(
          children: [
            Container(
                child: CarouselWithIndicator(
              isAds: true,
              ads: appGet.advertisments,
            )),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: Container(
                child: Obx(() {
                  return appGet.markets.isNotEmpty
                      ? ListView.builder(
                          itemCount: appGet.markets.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    log(appGet.markets[index]
                                        .toMarketJson()
                                        .toString());
                                    if (appGet.markets[index].userId != null) {
                                      appGet.getMarketProducts(
                                          appGet.markets[index].userId!);
                                      Get.to(MarketPage(
                                        appUser: appGet.markets[index],
                                      ));
                                    }
                                  },
                                  child: MarketWidget(
                                    appUser: appGet.markets[index],
                                  ),
                                );
                              }),
                            );
                          },
                        )
                      : Center(
                          child: Text('no_data'.tr),
                        );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
