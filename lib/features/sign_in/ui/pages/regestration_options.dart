import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/sign_in/ui/pages/customer_registration.dart';
import 'package:mashatel/features/sign_in/ui/pages/market_registration.dart';
import 'package:mashatel/features/sign_in/ui/widgets/circle_button.dart';
import 'package:mashatel/values/styles.dart';

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
        title: Text(translator.translate('Regestration')),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ListTile(
              title: Text(
                translator.translate('new_user'),
                style: Styles.titleTextStyle,
              ),
              subtitle: Text(translator.translate('new_user_note')),
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
