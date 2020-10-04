import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/modles/bigAds.dart';
import 'package:mashatel/features/customers/modles/category.dart';
import 'package:mashatel/services/connectvity_service.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/widgets/TextField.dart';
import 'package:mashatel/widgets/custom_drawer.dart';
import 'package:mashatel/widgets/primary_button.dart';

class NewBannerAd extends StatefulWidget {
  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewBannerAd> {
  AppGet appGet = Get.put(AppGet());

  GlobalKey<FormState> formKey = GlobalKey();

  bool isUploaded = false;

  String nameEn;

  String nameAr;

  setCatNameAr(String value) {
    this.nameAr = value;
  }

  setCatNameEn(String value) {
    this.nameEn = value;
  }

  nullValidation(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    }
  }

  saveForm() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (ConnectivityService.connectivityStatus !=
          ConnectivityStatus.Offline) {
        String catId = await appGet.addBannerAd(nameAr, nameEn);
        if (catId != null) {
          CustomDialougs.utils
              .showSackbar(messageKey: 'success_ad_added', titleKey: 'success');
        } else {
          CustomDialougs.utils
              .showSackbar(messageKey: 'faild_ad_added', titleKey: 'faild');
        }
      } else {
        CustomDialougs.utils
            .showDialoug(messageKey: 'network_error', titleKey: 'alert');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: AppSettings(appGet.appUser.value),
      appBar: AppBar(
        title: Text(translator.translate('new_ad')),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      MyTextField(
                        hintTextKey: 'nameAr',
                        nofLines: 1,
                        saveFunction: setCatNameAr,
                        validateFunction: nullValidation,
                      ),
                      MyTextField(
                        hintTextKey: 'nameEn',
                        nofLines: 1,
                        saveFunction: setCatNameEn,
                        validateFunction: nullValidation,
                      )
                    ],
                  )),
              PrimaryButton(
                  color: AppColors.primaryColor,
                  textKey: 'add',
                  buttonPressFun: saveForm)
            ],
          ),
        ),
      ),
    );
  }
}
