import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/values/radii.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

class uploadMultibleFile extends StatefulWidget {
  @override
  _uploadFileState createState() => _uploadFileState();
}

class _uploadFileState extends State<uploadMultibleFile> {
  File? marketLogo;
  AppGet appGet = Get.put(AppGet());
  List<Asset> images = [];

//////////////////////////////////////////////////////////////////////////////////////////
  Future<void> loadAssets() async {
    List<Asset> resultList = [];
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        iosOptions: IOSOptions(
          settings: CupertinoSettings(
              selection: SelectionSetting(max: 9), previewEnabled: true),
          doneButton: UIBarButtonItem(title: 'Confirm'),
          cancelButton: UIBarButtonItem(title: 'Cancel'),
          albumButtonColor: Theme.of(context).colorScheme.primary,
        ),
        selectedAssets: images,
        androidOptions: AndroidOptions(
          actionBarColor: Color(0xffabcdef),
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          selectCircleStrokeColor: Color(0xff000000),
          selectionLimitReachedText: "Selection limit reached",
        ),
      );
      appGet.setImagesAssets(resultList);
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }
///////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 60.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(new Radius.circular(50.0.h)),
            border: Border.all(color: AppColors.primaryColor)),
        padding: EdgeInsets.only(right: 0.w),
        margin: EdgeInsets.only(bottom: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Obx(() => Container(
                    alignment: Alignment.center,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: appGet.images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Chip(
                            label: Text(appGet.images[index].name ?? '',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(15.sp),
                                )),
                            deleteIcon: Opacity(
                              opacity: 0.5,
                              child: Icon(
                                FontAwesomeIcons.solidTimesCircle,
                                size: 15.w,
                              ),
                            ),
                            onDeleted: () {
                              appGet.deleteAssetImage(appGet.images[index]);
                            },
                          ),
                        );
                      },
                    ),
                  )),
            ),
            Container(
              height: 55.h,
              child: ElevatedButton(
                  child: Icon(
                    FontAwesomeIcons.upload,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape:
                        RoundedRectangleBorder(borderRadius: Radii.k8pxRadius),
                  ),
                  onPressed: () => loadAssets()),
            )
          ],
        ));
  }
}
