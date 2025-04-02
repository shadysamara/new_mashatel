import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/values/styles.dart';
import 'package:mashatel/widgets/custom_drawer.dart';

class AboutApp extends StatelessWidget {
  AppGet appGet = Get.put(AppGet());
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 392.72727272727275,
        height: 850.9090909090909,
        allowFontScaling: true);
    return Scaffold(
      endDrawer: AppSettings(appGet.appUser.value),
      appBar: AppBar(
        title: Text(translator.translate('About_app')),
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
              translator.translate('About_app'),
              style: Styles.headerStyle,
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: appGet.aboutAppModel.isNull
                  ? Center(
                      child: Text(translator.translate('no_data')),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(translator.currentLanguage == 'ar'
                              ? appGet.aboutAppModel.nameAr
                              : appGet.aboutAppModel.nameEn),
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
