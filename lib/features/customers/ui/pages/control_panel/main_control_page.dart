import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/about_app/insert_about_app.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/add_advertisment.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/all_ads.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/new_category.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/terms_and_conditions/insert_terms.dart';
import 'package:mashatel/features/customers/ui/widgets/control_panel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/widgets/custom_appbar.dart';
import 'package:mashatel/widgets/custom_drawer.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/reported_products.dart';

class ControlPanelPage extends StatelessWidget {
  AppGet appGet = Get.put(AppGet());
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: AppSettings(appGet.appUser.value),
      appBar: BaseAppbar('control_panel'),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ControlPnelWidget(
                iconData: FontAwesomeIcons.store,
                title: 'add_category',
                fun: () {
                  Get.to(NewCategory());
                },
              ),
              ControlPnelWidget(
                iconData: FontAwesomeIcons.ad,
                title: 'add_ad',
                fun: () {
                  Get.to(AllAds());
                },
              ),
              ControlPnelWidget(
                iconData: FontAwesomeIcons.info,
                title: 'add_about_app',
                fun: () {
                  Get.to(NewAboutApp());
                },
              ),
              ControlPnelWidget(
                iconData: FontAwesomeIcons.gavel,
                title: 'add_terms',
                fun: () {
                  Get.to(NewTerms());
                },
              ),
              ControlPnelWidget(
                iconData: Icons.block,
                title: 'reported_products',
                fun: () {
                  Get.to(ReportedProducts());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
