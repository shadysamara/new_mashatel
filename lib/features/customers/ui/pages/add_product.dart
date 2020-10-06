import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/modles/product_model.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/features/sign_in/ui/widgets/upload_multi_images.dart';
import 'package:mashatel/features/sign_in/ui/widgets/upload_file.dart';
import 'package:mashatel/services/connectvity_service.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/widgets/TextField.dart';
import 'package:mashatel/widgets/primary_button.dart';

class AddNewProduct extends StatefulWidget {
  @override
  _MarketRegistrationPageState createState() => _MarketRegistrationPageState();
}

class _MarketRegistrationPageState extends State<AddNewProduct> {
  GlobalKey<FormState> advFormKey = GlobalKey();

  String nameAr;

  String nameEn;

  String descAr;

  String descEn;

  double price;

  File adImage;

  bool isInnerMessages = false;
  bool isWithoutPhoneNumber = false;
  bool isShady = false;
  final SignInGetx signInGetx = Get.put(SignInGetx());
  final AppGet appGet = Get.put(AppGet());

  setNameAr(String value) {
    this.nameAr = value;
  }

  setNameEn(String value) {
    this.nameEn = value;
  }

  setDescAr(String value) {
    this.descAr = value;
  }

  setDescEn(String value) {
    this.descEn = value;
  }

  setPrice(String value) {
    this.price = double.parse(value);
  }

  setFileImage(File value) {
    this.adImage = value;
  }

  setIsInnerMessages(bool value) {
    setState(() {
      this.isInnerMessages = value;
    });
  }

  setIsWithoutPhoneNumber(bool value) {
    setState(() {
      this.isWithoutPhoneNumber = value;
    });
  }

  nullValidation(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    }
  }

  numberValidation(String value) {
    print(value);
    if (value.isEmpty) {
      return translator.translate('null_error');
    }
  }

  saveForm() async {
    if (advFormKey.currentState.validate()) {
      if (appGet.images.isNotEmpty) {
        advFormKey.currentState.save();
        ProductModel advertisment = ProductModel(
            descAr: this.descAr,
            descEn: this.descEn,
            assetImages: appGet.images,
            isInnerMessages: this.isInnerMessages,
            isWithoutPhoneNumber: this.isWithoutPhoneNumber,
            nameAr: this.nameAr,
            nameEn: this.nameEn,
            price: this.price,
            marketId: appGet.appUser.value.userId);

        if (ConnectivityService.connectivityStatus !=
            ConnectivityStatus.Offline) {
          signInGetx.pr.show();
          String adId = await MashatelClient.mashatelClient
              .addNewProductWithManyImages(advertisment, appGet.appUser.value);
          appGet.images.value = [];
          advFormKey.currentState.reset();
          signInGetx.pr.hide();

          if (!adId.isNull) {
            CustomDialougs.utils.showSackbar(
                messageKey: 'success_product_added', titleKey: 'success');

            Future.delayed(Duration(seconds: 3)).then((value) => Get.back());
          }
        } else {
          signInGetx.pr.hide();
          CustomDialougs.utils
              .showDialoug(messageKey: 'network_error', titleKey: 'alert');
          Future.delayed(Duration(seconds: 3)).then((value) => Get.back());
        }

        // Auth.authInstance.registerUsingEmailAndPassword(email, password);
      } else {
        CustomDialougs.utils
            .showDialoug(messageKey: 'file_error', titleKey: 'missing_element');
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.translate('new_product')),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: Form(
            key: advFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextField(
                      hintTextKey: 'product_ar',
                      nofLines: 1,
                      validateFunction: nullValidation,
                      saveFunction: setNameAr),
                  MyTextField(
                    hintTextKey: 'product_en',
                    nofLines: 1,
                    validateFunction: nullValidation,
                    saveFunction: setNameEn,
                  ),
                  MyTextField(
                    hintTextKey: 'descAr',
                    nofLines: 1,
                    validateFunction: nullValidation,
                    saveFunction: setDescAr,
                  ),
                  MyTextField(
                    hintTextKey: 'descEn',
                    nofLines: 1,
                    validateFunction: nullValidation,
                    saveFunction: setDescEn,
                  ),
                  MyTextField(
                    hintTextKey: 'price',
                    nofLines: 1,
                    validateFunction: numberValidation,
                    saveFunction: setPrice,
                    textInputType: TextInputType.number,
                  ),
                  uploadMultibleFile(),
                  Text(translator.translate('ad_settings')),
                  CheckboxListTile(
                      title: Text(translator.translate('isInnerMessages')),
                      activeColor: AppColors.primaryColor,
                      value: isInnerMessages,
                      onChanged: (value) => setIsInnerMessages(value)),
                  CheckboxListTile(
                      title: Text(translator.translate('isWithoutPhoneNumber')),
                      activeColor: AppColors.primaryColor,
                      value: isWithoutPhoneNumber,
                      onChanged: (value) => setIsWithoutPhoneNumber(value)),
                  PrimaryButton(
                    buttonPressFun: saveForm,
                    textKey: 'register',
                  )
                ],
              ),
            )),
      ),
    );
  }
}
