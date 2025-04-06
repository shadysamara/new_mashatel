import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/modles/category.dart';
import 'package:mashatel/services/connectvity_service.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/widgets/TextField.dart';
import 'package:mashatel/widgets/custom_appbar.dart';
import 'package:mashatel/widgets/custom_drawer.dart';
import 'package:mashatel/widgets/primary_button.dart';

class NewCategory extends StatefulWidget {
  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  AppGet appGet = Get.put(AppGet());

  GlobalKey<FormState> formKey = GlobalKey();

  bool isUploaded = false;

  File? imageFile;

  String? nameEn;

  String? nameAr;

  setCatNameAr(String value) {
    this.nameAr = value;
  }

  setCatNameEn(String value) {
    this.nameEn = value;
  }

  nullValidation(String value) {
    if (value.isEmpty) {
      return 'null_error'.tr;
    }
  }

  saveForm() async {
    if (formKey.currentState?.validate() == true) {
      if (appGet.imagePath.value.isNotEmpty) {
        formKey.currentState?.save();
        if (ConnectivityService.connectivityStatus !=
            ConnectivityStatus.Offline) {
          Category category =
              Category(nameAr: this.nameAr, nameEn: this.nameEn);
          String? catId = await appGet.addNewCategory(category);
          if (catId != null) {
            CustomDialougs.utils.showSackbar(
                messageKey: 'success_category_added', titleKey: 'success');
            appGet.imagePath.value = '';
          } else {
            CustomDialougs.utils.showSackbar(
                messageKey: 'faild_category_added', titleKey: 'faild');
            appGet.imagePath.value = '';
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
    return Scaffold(
      appBar: BaseAppbar('new_category'),
      endDrawer: AppSettings(appGet.appUser.value),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(onTap: () async {
                appGet.imagePath.value = '';
                XFile? pickImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickImage == null) {
                  return;
                }
                this.imageFile = File(pickImage.path);
                appGet.setLocalImageFile(imageFile!);
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
                  onPressed: () {
                    if (imageFile != null) {
                      appGet.uploadImage(imageFile!);
                    }
                  },
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
                  onPressed: saveForm)
            ],
          ),
        ),
      ),
    );
  }
}
