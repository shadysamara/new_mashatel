import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/markets_page.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/new_category.dart';
import 'package:mashatel/features/customers/ui/widgets/main_category_widget.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';
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
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      appBar: BaseAppbar('categories'),
      drawer: AppSettings(appGet.appUser.value),
      body: Container(
        child: Column(
          children: [
            Container(
                child: CarouselWithIndicatorDemo(
              isAds: true,
              ads: appGet.advertisments,
            )),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Obx(() {
                  return appGet.allCategories.isNotEmpty
                      ? ListView.builder(
                          itemCount: appGet.allCategories.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    appGet.getAllMarkets(
                                        appGet.allCategories[index].catId);
                                    Get.to(MarketsPage());
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
                          child: Text('No Data Found'),
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
