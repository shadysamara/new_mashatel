import 'package:mashatel/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Styles {
  static TextStyle titleTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: ScreenUtil().setSp(17.sp),
      fontFamily: "DIN");

  static TextStyle subTitleTextStyle =
      TextStyle(fontSize: ScreenUtil().setSp(15.sp));
  static TextStyle hyperlinkText = TextStyle(
      fontSize: ScreenUtil().setSp(17.sp), color: AppColors.primaryColor);
  static TextStyle appBarTitle = TextStyle(color: Colors.white);
  static TextStyle profileText =
      TextStyle(fontSize: ScreenUtil().setSp(17.sp), color: Colors.black);
  static TextStyle profileValuesText =
      TextStyle(fontSize: ScreenUtil().setSp(17.sp), color: Color(0xff707070));

  static TextStyle headerStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: ScreenUtil().setSp(25.sp),
      color: Color(0xff707070));
}
