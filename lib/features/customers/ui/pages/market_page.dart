import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/product_details/product_Details_main.dart';
import 'package:mashatel/features/customers/ui/widgets/advertisment_widget.dart';
import 'package:mashatel/features/customers/ui/widgets/product_widget.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/widgets/custom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/widgets/custom_drawer.dart';

class MarketPage extends StatelessWidget {
  AppUser appUser;
  MarketPage(this.appUser);
  AppGet appGet = Get.put(AppGet());
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 392.72727272727275,
        height: 850.9090909090909,
        allowFontScaling: true);
    return WillPopScope(
      onWillPop: () {
        appGet.products.value = [];
        return Future.value(true);
      },
      child: Scaffold(
        endDrawer: AppSettings(appGet.appUser.value),
        appBar: BaseAppbar(appUser != null ? appUser.userName : ''),
        // drawer: AppSettings(appGet.appUser.value),
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Obx(() {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 5.w,
                        mainAxisSpacing: 15.h),
                    itemCount: appGet.products.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Get.to(ProductDetails(
                                appGet.products[index], appUser));
                          },
                          child: Container(
                            child: ProductWidget(appGet.products[index]),
                          ));
                    },
                  );
                }),
              ),
            ),
            AdvertismentWidget(
                appGet.advertisments[
                    Random().nextInt(appGet.advertisments.length)],
                0),
          ],
        ),
      ),
    );
  }
}
