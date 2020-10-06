import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/modles/advertisment.dart';
import 'package:mashatel/features/customers/modles/category.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/services/connectvity_service.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/widgets/TextField.dart';
import 'package:mashatel/widgets/custom_drawer.dart';
import 'package:mashatel/widgets/primary_button.dart';
import 'package:string_validator/string_validator.dart';

class AddNewPage extends StatefulWidget {
  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<AddNewPage> {
  AppGet appGet = Get.put(AppGet());

  GlobalKey<FormState> formKey = GlobalKey();

  bool isUploaded = false;

  File imageFile;

  String url;

  setUrl(String value) {
    this.url = value;
  }

  nullValidation(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    } else if (!isURL(value)) {
      return translator.translate('invalid_url');
    }
  }

  saveForm() async {
    if (formKey.currentState.validate()) {
      if (appGet.imagePath.value.isNotEmpty) {
        formKey.currentState.save();
        if (ConnectivityService.connectivityStatus !=
            ConnectivityStatus.Offline) {
          Advertisment advertisment =
              Advertisment(url: this.url, imageUrl: appGet.imagePath.value);
          String catId =
              await MashatelClient.mashatelClient.addNewAdv(advertisment);
          if (catId != null) {
            CustomDialougs.utils.showSackbar(
                messageKey: 'success_ad_added', titleKey: 'success');
          } else {
            CustomDialougs.utils
                .showSackbar(messageKey: 'faild_ad_added', titleKey: 'faild');
          }
        } else {
          CustomDialougs.utils
              .showDialoug(messageKey: 'network_error', titleKey: 'alert');
        }
      } else {
        CustomDialougs.utils
            .showDialoug(messageKey: 'uploaded_image_error', titleKey: 'alert');
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
              GestureDetector(onTap: () async {
                appGet.imagePath.value = '';
                PickedFile pickImage =
                    await ImagePicker().getImage(source: ImageSource.gallery);
                this.imageFile = File(pickImage.path);
                appGet.setLocalImageFile(imageFile);
              }, child: Obx(() {
                return appGet.localImageFilePath.value.isNotEmpty
                    ? appGet.imagePath.value.isNotEmpty
                        ? Container(
                            width: 200.w,
                            height: 200.h,
                            child: Image.file(
                              File(appGet.localImageFilePath.value),
                              fit: BoxFit.fill,
                            ),
                          )
                        : Container(
                            width: 200.w,
                            height: 200.h,
                            child: Opacity(
                                opacity: 0.1,
                                child: Image.file(
                                  File(appGet.localImageFilePath.value),
                                )),
                          )
                    : Container(
                        width: 150.w,
                        height: 150.h,
                        color: Colors.grey[400],
                        child: Icon(Icons.add),
                      );
              })),
              SizedBox(
                height: 30.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: PrimaryButton(
                  color: AppColors.primaryColor,
                  textKey: 'upload_image',
                  buttonPressFun: () => appGet.uploadImage(imageFile),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      MyTextField(
                        hintTextKey: 'url',
                        nofLines: 1,
                        saveFunction: setUrl,
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
