import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/modles/terms.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/services/connectvity_service.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/widgets/TextField.dart';
import 'package:mashatel/widgets/custom_appbar.dart';
import 'package:mashatel/widgets/custom_drawer.dart';
import 'package:mashatel/widgets/primary_button.dart';

class NewTerms extends StatefulWidget {
  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewTerms> {
  SignInGetx signInGetx = Get.put(SignInGetx());
  AppGet appGet = Get.put(AppGet());
  GlobalKey<FormState> termsFormKey = GlobalKey();

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
    if (termsFormKey.currentState?.validate() == true) {
      termsFormKey.currentState?.save();
      if (ConnectivityService.connectivityStatus !=
          ConnectivityStatus.Offline) {
        signInGetx.pr.show();
        TermsModel termsModel =
            TermsModel(nameAr: this.nameAr, nameEn: this.nameEn);
        bool isDone = await MashatelClient.mashatelClient
            .addTermsAndConditions(termsModel);
        if (isDone) {
          signInGetx.pr.hide();
          appGet.setTermsModel(termsModel);
          CustomDialougs.utils
              .showSackbar(messageKey: 'success_terms', titleKey: 'success');
          Future.delayed(Duration(seconds: 3)).then((value) => Get.back());
        } else {
          signInGetx.pr.hide();
          CustomDialougs.utils
              .showSackbar(messageKey: 'failed_terms', titleKey: 'faild');
          Future.delayed(Duration(seconds: 3)).then((value) => Get.back());
        }
      } else {
        CustomDialougs.utils
            .showDialoug(messageKey: 'network_error', titleKey: 'alert');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppSettings(appGet.appUser.value),
      appBar: BaseAppbar('conditions'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: termsFormKey,
                  child: Column(
                    children: [
                      MyTextField(
                        hintTextKey: 'contentAr',
                        nofLines: 1,
                        saveFunction: setCatNameAr,
                        validateFunction: nullValidation,
                      ),
                      MyTextField(
                        hintTextKey: 'contentEn',
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
