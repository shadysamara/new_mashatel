import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/markets_page.dart';
import 'package:mashatel/features/customers/ui/widgets/main_category_widget.dart';
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
      appBar: BaseAppbar('categories'),
      endDrawer: AppSettings(appGet.appUser.value),
      body: Container(
        child: Column(
          children: [
            Container(
                child: CarouselWithIndicator(
              isAds: true,
              ads: appGet.advertisments,
            )),
            Expanded(
              child: Container(
                child: Obx(() {
                  return appGet.allCategories.isNotEmpty
                      ? ListView.builder(
                          itemCount: appGet.allCategories.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    log(appGet.allCategories[index]
                                        .toJson()
                                        .toString());
                                    if (appGet.allCategories[index].catId !=
                                        null) {
                                      appGet.getAllMarkets(
                                          appGet.allCategories[index].catId!);
                                      Get.to(MarketsPage());
                                    }
                                  },
                                  child: CategoryWidget(
                                    category: appGet.allCategories[index],
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
