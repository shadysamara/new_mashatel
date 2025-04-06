import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/values/radii.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class ProgressDialogUtils {
  static ProgressDialog? pr;

  ProgressDialogUtils(BuildContext context);
  bool dialougIsShown = false;
  void show() {
    dialougIsShown = true;
    Get.dialog<void>(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.sp),
                color: Colors.white),
            height: 50.sp,
            width: 50.sp,
            child: CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 3,
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  bool _isCompleted = false;
  bool get isLoading => !_isCompleted;
  void hide() {
    if (dialougIsShown) {
      dialougIsShown = false;
      Get.back<void>();
    }
  }
}
