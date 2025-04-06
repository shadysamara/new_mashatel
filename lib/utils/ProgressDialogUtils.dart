import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/values/radii.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class ProgressDialogUtils extends ProgressDialog {
  static ProgressDialog? pr;

  ProgressDialogUtils(BuildContext context) : super(context);

  static ProgressDialog createProgressDialog(BuildContext context) {
    pr = new ProgressDialog(
      context,
      customBody: Container(
        decoration: BoxDecoration(borderRadius: Radii.k8pxRadius),
        height: 200.h,
        width: 200.w,
        child: CircularProgressIndicator(),
      ),
      type: ProgressDialogType.normal,
      isDismissible: true,
    );
    pr?.style(
      message: "processing_order".tr,
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 13.0,
          fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.normal),
    );
    return pr!;
  }

  void showProgressDialog() {
    if (pr != null) {
      pr!.show();
    }
  }

  void hideProgressDialog() {
    if (pr != null) {
      pr!.hide();
    }
  }
}
