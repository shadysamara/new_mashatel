import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/values/styles.dart';
import 'package:mashatel/widgets/custom_drawer.dart';

class TermsPage extends StatelessWidget {
  AppGet appGet = Get.put(AppGet());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppSettings(appGet.appUser.value),
      appBar: AppBar(
        title: Text('conditions'.tr),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 220.h,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            Text(
              'conditions'.tr,
              style: Styles.headerStyle,
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: appGet.termsModel.isNull
                  ? Center(
                      child: Text('no_data'.tr),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Text((Get.locale == Locale('ar')
                                  ? appGet.termsModel?.nameAr
                                  : appGet.termsModel?.nameEn) ??
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
