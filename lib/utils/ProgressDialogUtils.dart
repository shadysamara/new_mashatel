import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/values/radii.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressDialogUtils extends ProgressDialog {
  static ProgressDialog pr;

  ProgressDialogUtils(BuildContext context) : super(context);

  static ProgressDialog createProgressDialog(BuildContext context) {
    pr = new ProgressDialog(
      context,
      customBody: Container(
        decoration: BoxDecoration(borderRadius: Radii.k8pxRadius),
        height: 200.h,
        width: 200.w,
        child: FlareActor(
          "assets/animations/loading.flr",
          sizeFromArtboard: true,
          alignment: Alignment.center,
          fit: BoxFit.cover,
          animation: "loading",
        ),
      ),
      type: ProgressDialogType.Normal,
      isDismissible: true,
    );
    pr.style(
      message: translator.translate("processing_order"),
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 13.0,
          fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.normal),
    );
    return pr;
  }

  void showProgressDialog() {
    if (pr != null) {
      pr.show();
    }
  }

  void hideProgressDialog() {
    if (pr != null) {
      pr.hide();
    }
  }
}
