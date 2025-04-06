import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:mashatel/features/customers/ui/pages/main_page.dart';
import 'package:mashatel/features/sign_in/ui/pages/login_page_test.dart';
import 'package:mashatel/features/sign_in/ui/pages/regestration_options.dart';
import 'package:mashatel/widgets/primary_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final controller = PageController(viewportFraction: 0.8);

  List images = [
    'assets/images/product1.jpg',
    'assets/images/product2.jpg',
    'assets/images/product3.jpg',
    'assets/images/product4.jpg'
  ];

  List<Widget> buildSlider() {
    final List<Widget> imageSliders = images
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Image.asset(
                    item,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ))
        .toList();

    return imageSliders;
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 60.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'app_title'.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(20.sp)),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
                Container(
                    child: CarouselSlider(
                        items: buildSlider(),
                        options: CarouselOptions(
                          height: 400.h,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            this.index = index;
                            setState(() {});
                          },
                        ))),
                Container(
                    child: AnimatedSmoothIndicator(
                  activeIndex: index,
                  count: 4,
                  effect: WormEffect(dotHeight: 10.h, dotWidth: 10.w),
                )),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: PrimaryButton(
                      textKey: 'start_shopping'.tr,
                      color: Colors.black.withOpacity(0.5),
                      onPressed: () {
                        Get.off(MainPage());
                      },
                    )),
                Container(
                  width: 200.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.off(RegistrationOptionsPage());
                          },
                          child: Text('register'.tr)),
                      Text('or'.tr),
                      GestureDetector(
                          onTap: () {
                            Get.off(LoginScreen());
                          },
                          child: Text('login'.tr))
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
