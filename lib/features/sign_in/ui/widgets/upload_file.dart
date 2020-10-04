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
  File marketLogo;
  SignInGetx signInGetx = Get.find();
  saveLogo() async {
    PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery);
    this.marketLogo = File(file.path);
    String fileName = marketLogo.path.substring(
        marketLogo.path.lastIndexOf('/') + 1, marketLogo.path.length);
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
        padding: EdgeInsets.only(left: 10.w, right: 2.w),
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
                  fontSize: ScreenUtil().setSp(15, allowFontScalingSelf: true),
                ),
              ),
            ),
            Container(
              height: 55.h,
              child: RaisedButton(
                  child: Icon(
                    FontAwesomeIcons.upload,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: Radii.k8pxRadius),
                  onPressed: () => saveLogo()),
            )
          ],
        ));
  }
}
