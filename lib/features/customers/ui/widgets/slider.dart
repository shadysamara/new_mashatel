// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:mashatel/features/customers/blocs/app_get.dart';
// import 'package:mashatel/values/colors.dart';

// class CarouselWithIndicatorDemo extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _CarouselWithIndicatorState();
//   }
// }

// class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
//   int _current = 0;
//   AppGet appGet = Get.put(AppGet());
//   final List<Widget> imageSliders = imgList
//       .map((item) => Container(
//             child: Container(
//               margin: EdgeInsets.all(5.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                 child: CachedNetworkImage(
//                   imageUrl: item,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//               ),
//             ),
//           ))
//       .toList();

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Column(children: [
//       CarouselSlider(
//         items: Obx(() {
//           return appGet.mainAdsImagesUrls.value.map((item) => Container(
//             child: Container(
//               margin: EdgeInsets.all(5.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                 child: CachedNetworkImage(
//                   imageUrl: item.imageUrl,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//               ),
//             ),
//           )).toList();
//         }),
//         options: CarouselOptions(
//             autoPlay: true,
//             enlargeCenterPage: true,
//             height: size.height / 5,
//             onPageChanged: (index, reason) {
//               setState(() {
//                 //// change indicator
//                 _current = index;
//               });
//             }),
//       ),
//       ///// indicators
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: imgList.map((url) {
//           int index = imgList.indexOf(url);
//           return Container(
//             width: 8.0.w,
//             height: 8.0.h,
//             margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: _current == index
//                   ? AppColors.primaryColor
//                   : AppColors.greyBackground,
//             ),
//           );
//         }).toList(),
//       ),
//     ]);
//   }
// }
