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
  AppUser? appUser;
  MarketPage({this.appUser});
  AppGet appGet = Get.put(AppGet());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        appGet.products.value = [];
        return Future.value(true);
      },
      child: Scaffold(
        endDrawer: AppSettings(appGet.appUser.value),
        appBar: BaseAppbar(appUser != null ? appUser?.userName ?? '' : ''),
        // drawer: AppSettings(appGet.appUser.value),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Text('categories'.tr,
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
            Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {
                        appGet.catId.value = "all";
                        appGet.cateroizedProducts.value = appGet.products;
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 15.h),
                        decoration: BoxDecoration(
                            color: appGet.catId.value == "all"
                                ? Colors.white
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                                color: appGet.catId.value == "all"
                                    ? Colors.black
                                    : Colors.grey)),
                        child: Text("all".tr,
                            style: TextStyle(
                                fontSize: 14.sp,
                                height: 0.5,
                                color: appGet.catId.value == "all"
                                    ? Colors.black
                                    : Colors.grey)),
                      ),
                    ),
                    ...appGet.allCategories.map((e) {
                      return GestureDetector(
                        onTap: () {
                          appGet.catId.value = e.catId!;
                          appGet.getProductsByCategory(e.catId!);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 15.h),
                          decoration: BoxDecoration(
                              color: appGet.catId.value == e.catId
                                  ? Colors.white
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                  color: appGet.catId.value == e.catId
                                      ? Colors.black
                                      : Colors.grey)),
                          child: Text(e.nameAr ?? '',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  height: 0.5,
                                  color: appGet.catId.value == e.catId
                                      ? Colors.black
                                      : Colors.grey)),
                        ),
                      );
                    }).toList()
                  ]),
                )),
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
                    itemCount: appGet.cateroizedProducts.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            if (appUser != null) {
                              Get.to(ProductDetails(
                                  appGet.cateroizedProducts[index], appUser!));
                            }
                          },
                          child: Container(
                            child:
                                ProductWidget(appGet.cateroizedProducts[index]),
                          ));
                    },
                  );
                }),
              ),
            ),
            // AdvertismentWidget(
            //     appGet.advertisments[
            //         Random().nextInt(appGet.advertisments.length)],
            //     0),
          ],
        ),
      ),
    );
  }
}
