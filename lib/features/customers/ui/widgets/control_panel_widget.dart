import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/modles/category.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/values/radii.dart';
import 'package:mashatel/values/styles.dart';

class ControlPnelWidget extends StatelessWidget {
  IconData iconData;
  String title;
  Function fun;
  ControlPnelWidget({this.iconData, this.fun, this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        fun();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: Radii.widgetsRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ]),
        child: ClipRRect(
          borderRadius: Radii.widgetsRadius,
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(color: AppColors.primaryColor),
                child: Icon(
                  this.iconData,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(right: 10.w, top: 10.h, bottom: 10.h),
                  child: Text(
                    translator.translate(title),
                    style: Styles.headerStyle.copyWith(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
