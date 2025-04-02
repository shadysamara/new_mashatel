import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/sign_in/models/customer_model.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';
import 'package:mashatel/features/sign_in/ui/pages/testpage.dart';
import 'package:mashatel/features/sign_in/ui/widgets/upload_file.dart';
import 'package:mashatel/services/connectvity_service.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/values/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/values/values.dart';
import 'package:mashatel/widgets/TextField.dart';
import 'package:mashatel/widgets/primary_button.dart';
import 'package:string_validator/string_validator.dart';

class CustomerRegistrationPage extends StatefulWidget {
  @override
  _customerRegistrationPageState createState() =>
      _customerRegistrationPageState();
}

class _customerRegistrationPageState extends State<CustomerRegistrationPage> {
  GlobalKey<FormState> customerRegFormKey = GlobalKey();

  String userName;

  String password;

  String phoneNumber;

  String email;
  final SignInGetx signInGetx = Get.put(SignInGetx());
  saveEmail(String value) {
    this.email = value;
  }

  saveuserName(String value) {
    this.userName = value;
  }

  savepassword(String value) {
    this.password = value;
  }

  savephoneNumber(String value) {
    this.phoneNumber = value;
  }

  validatepasswordFunction(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    } else if (value.length < 8) {
      return translator.translate('password_error');
    }
  }

  validateEmailFunction(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    } else if (!isEmail(value)) {
      return translator.translate('email_error');
    }
  }

  nullValidation(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    }
  }

  saveForm() async {
    if (customerRegFormKey.currentState.validate()) {
      customerRegFormKey.currentState.save();
      AppUser customer = AppUser(
          userName: this.userName,
          phoneNumber: this.phoneNumber,
          email: this.email,
          password: this.password);
      if (ConnectivityService.connectivityStatus !=
          ConnectivityStatus.Offline) {
        signInGetx.pr.show();
        String id = await RegistrationClient.registrationIntance
            .registerAsCustomer(customer);
        if (!id.isNull) {
          signInGetx.pr.hide();
          Get.snackbar(
            translator.translate('market_snackbar_title'),
            translator.translate('customer_snackbar_message'),
            duration: Duration(seconds: 3),
          );
          signInGetx.setUserType(userType.customer);
          print('go to customer page');
        }
      } else {
        CustomDialougs.utils
            .showDialoug(messageKey: 'network_error', titleKey: 'alert');
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 392.72727272727275,
        height: 850.9090909090909,
        allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.translate('customers_register')),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: Form(
            key: customerRegFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/customers.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          translator.translate('customers_register'),
                          style: Styles.titleTextStyle,
                        ),
                      ],
                    ),
                    subtitle: Text(
                      translator.translate('customers_register_note'),
                      style: Styles.subTitleTextStyle,
                    ),
                  ),
                  MyTextField(
                    hintTextKey: 'user_name',
                    nofLines: 1,
                    validateFunction: nullValidation,
                    saveFunction: saveuserName,
                  ),
                  MyTextField(
                    hintTextKey: 'email',
                    nofLines: 1,
                    validateFunction: validateEmailFunction,
                    saveFunction: saveEmail,
                  ),
                  MyTextField(
                    hintTextKey: 'password',
                    nofLines: 1,
                    validateFunction: validatepasswordFunction,
                    saveFunction: savepassword,
                    textInputType: TextInputType.visiblePassword,
                  ),
                  MyTextField(
                    hintTextKey: 'tel_number',
                    nofLines: 1,
                    validateFunction: nullValidation,
                    saveFunction: savephoneNumber,
                    textInputType: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
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
