import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/values/radii.dart';

class uploadFile extends StatefulWidget {
  @override
  _uploadFileState createState() => _uploadFileState();
}

class _uploadFileState extends State<uploadFile> {
  File? marketLogo;
  SignInGetx signInGetx = Get.find();
  saveLogo() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }
    this.marketLogo = File(file.path);
    String fileName = marketLogo!.path.substring(
        marketLogo!.path.lastIndexOf('/') + 1, marketLogo!.path.length);
    fileName = fileName.length > 15
        ? fileName.substring(0, 15) +
            '.....' +
            fileName.substring(fileName.lastIndexOf('.') - 2, fileName.length)
        : fileName;
    signInGetx.fileName.value = fileName;
    signInGetx.file = this.marketLogo;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 60.h,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(new Radius.circular(50.0.h)),
            border: Border.all(color: AppColors.primaryColor)),
        padding: EdgeInsets.only(
            right: Get.locale == Locale("ar") ? 10.w : 0.w,
            left: Get.locale == Locale("ar") ? 0.w : 10.w),
        margin: EdgeInsets.only(bottom: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                signInGetx.fileName.value,
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
            ),
            Container(
              height: 60.h,
              width: 90.w,
              child: ElevatedButton(
                  child: Icon(
                    FontAwesomeIcons.upload,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape:
                        RoundedRectangleBorder(borderRadius: Radii.k8pxRadius),
                  ),
                  onPressed: () => saveLogo()),
            )
          ],
        ));
  }
}
