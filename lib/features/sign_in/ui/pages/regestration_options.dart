import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/sign_in/ui/pages/customer_registration.dart';
import 'package:mashatel/features/sign_in/ui/pages/market_registration.dart';
import 'package:mashatel/features/sign_in/ui/widgets/circle_button.dart';
import 'package:mashatel/values/styles.dart';
import 'package:mashatel/welcome_page.dart';

class RegistrationOptionsPage extends StatelessWidget {
  marketsButtonFun() {
    Get.to(MarketRegistrationPage());
  }

  cusomersButtonFun() {
    Get.to(CustomerRegistrationPage());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.off(WelcomePage());
          },
        ),
        title: Text(
          'registration'.tr,
          style: TextStyle(fontFamily: "DIN", fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ListTile(
              title: Text(
                'new_user'.tr,
                style: Styles.titleTextStyle,
              ),
              subtitle: Text('new_user_note'.tr),
            ),
            Expanded(
                child: CircleButton(
              svgUrl: 'assets/images/market.svg',
              titleKey: 'markets',
              pressFun: marketsButtonFun,
            )),
            Expanded(
                child: CircleButton(
              svgUrl: 'assets/images/customers.svg',
              titleKey: 'customers',
              pressFun: cusomersButtonFun,
            ))
          ],
        ),
      ),
    ));
  }
}
