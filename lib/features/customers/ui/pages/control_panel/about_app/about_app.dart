import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/values/styles.dart';
import 'package:mashatel/widgets/custom_drawer.dart';

class AboutApp extends StatelessWidget {
  AppGet appGet = Get.put(AppGet());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppSettings(appGet.appUser.value),
      appBar: AppBar(
        title: Text('About_app'.tr),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220.h,
              width: double.infinity,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            Text(
              'About_app'.tr,
              style: Styles.headerStyle,
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: appGet.aboutAppModel.isNull
                  ? Center(child: Text('no_data'.tr))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Text((Get.locale == Locale('ar')
                                  ? appGet.aboutAppModel?.nameAr
                                  : appGet.aboutAppModel?.nameEn) ??
                              ''),
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
