import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CircleButton extends StatelessWidget {
  String? titleKey;
  String? svgUrl;
  Function? pressFun;
  CircleButton({this.pressFun, this.svgUrl, this.titleKey});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      width: 180.w,
      height: 180.h,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: RawMaterialButton(
          splashColor: Colors.grey[100],
          elevation: 2.0,
          shape: CircleBorder(),
          onPressed: () => pressFun == null ? null : pressFun!(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                this.svgUrl ?? '',
                semanticsLabel: this.titleKey,
                height: 60.h,
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(this.titleKey?.tr ?? '')
            ],
          ),
        ),
      ),
    );
  }
}
