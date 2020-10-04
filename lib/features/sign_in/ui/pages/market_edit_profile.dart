import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/features/sign_in/ui/widgets/upload_file.dart';
import 'package:mashatel/services/connectvity_service.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/values/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/values/values.dart';
import 'package:mashatel/widgets/TextField.dart';
import 'package:mashatel/widgets/primary_button.dart';
import 'package:string_validator/string_validator.dart';

class EditMarketProfilePage extends StatefulWidget {
  @override
  _EditMarketProfilePageState createState() => _EditMarketProfilePageState();
}

class _EditMarketProfilePageState extends State<EditMarketProfilePage> {
  GlobalKey<FormState> editMarketProfile = GlobalKey();

  String companyName;

  String userName;

  String password;

  String email;

  String phoneNumber;

  File marketLogo;

  String comapnyActivity;

  final SignInGetx signInGetx = Get.put(SignInGetx());

  saveCompanyName(String value) {
    this.companyName = value;
  }

  saveuserName(String value) {
    this.userName = value;
  }

  savepassword(String value) {
    this.password = value;
  }

  saveemail(String value) {
    this.email = value;
  }

  savephoneNumber(String value) {
    this.phoneNumber = value;
  }

  saveLogo() async {
    PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery);
    this.marketLogo = File(file.path);
  }

  savecomapnyActivity(String value) {
    this.comapnyActivity = value;
  }

  validateEmailFunction(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    } else if (!isEmail(value)) {
      return translator.translate('email_error');
    }
  }

  validatepasswordFunction(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    } else if (value.length < 8) {
      return translator.translate('password_error');
    }
  }

  nullValidation(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    }
  }

  saveForm() {
    if (editMarketProfile.currentState.validate()) {
      if (signInGetx.file != null) {
        editMarketProfile.currentState.save();
        if (ConnectivityService.connectivityStatus !=
            ConnectivityStatus.Offline) {
          ////////////////////////////
        } else {
          CustomDialougs.utils
              .showDialoug(messageKey: 'network_error', titleKey: 'alert');
        }
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
        title: Text(translator.translate('edit_market_profile')),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: Form(
            key: editMarketProfile,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/market.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          translator.translate('edit_market_profile'),
                          style: Styles.titleTextStyle,
                        ),
                      ],
                    ),
                  ),
                  MyTextField(
                    hintTextKey: 'company_name',
                    nofLines: 1,
                    validateFunction: nullValidation,
                    saveFunction: saveCompanyName,
                  ),
                  MyTextField(
                    hintTextKey: 'user_name',
                    nofLines: 1,
                    validateFunction: nullValidation,
                    saveFunction: saveuserName,
                  ),
                  MyTextField(
                    hintTextKey: 'password',
                    nofLines: 1,
                    validateFunction: validatepasswordFunction,
                    saveFunction: savepassword,
                    textInputType: TextInputType.visiblePassword,
                  ),
                  MyTextField(
                    hintTextKey: 'email',
                    nofLines: 1,
                    validateFunction: validateEmailFunction,
                    saveFunction: saveemail,
                    textInputType: TextInputType.emailAddress,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: AppColors.primaryColor,
                    ),
                    title: Text(translator.translate('company_location')),
                  ),
                  MyTextField(
                    hintTextKey: 'tel_number',
                    nofLines: 1,
                    validateFunction: nullValidation,
                    saveFunction: savephoneNumber,
                    textInputType: TextInputType.phone,
                  ),
                  uploadFile(),
                  MyTextField(
                    hintTextKey: 'company_activity',
                    nofLines: 1,
                    validateFunction: nullValidation,
                    saveFunction: savecomapnyActivity,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          buttonPressFun: saveForm,
                          textKey: 'save',
                        ),
                      ),
                      SizedBox(
                        width: 60.w,
                      ),
                      Expanded(
                        child: PrimaryButton(
                          buttonPressFun: saveForm,
                          textKey: 'undo',
                          color: Color(0xff888888),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
