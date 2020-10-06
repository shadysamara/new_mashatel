import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/main_page.dart';
import 'package:mashatel/features/customers/ui/pages/market_page.dart';
import 'package:mashatel/features/sign_in/models/sp_user.dart';

import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/sign_in/ui/pages/regestration_options.dart';
import 'package:mashatel/features/sign_in/ui/pages/testpage.dart';
import 'package:mashatel/services/connectvity_service.dart';

import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/widgets/TextField.dart';
import 'package:mashatel/widgets/primary_button.dart';

import 'package:mashatel/services/shared_prefrences_helper.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/widgets/empty_status_bar.dart';
import 'package:string_validator/string_validator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AppGet appGet = Get.put(AppGet());

  String userName;
  String password;
  saveUserName(String value) {
    this.userName = value;
  }

  savePassword(String value) {
    this.password = value;
  }

  validatepasswordFunction(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    } else if (value.length < 8) {
      return translator.translate('password_error');
    }
  }

  validateEmailFunction(String value) {
    final bool isValid = isEmail(value.trim());
    if (value.isEmpty) {
      return translator.translate("enter_your_username");
    } else if (!isNumeric(value) && !isValid) {
      return translator.translate("your_email_invalid");
    }
    return null;
  }

  SignInGetx signInGetx = Get.put(SignInGetx());
  Widget _loginLabel(context) {
    return Container(
      margin: EdgeInsets.only(top: 25.h, bottom: 25.h),
      child: Text(
        translator.translate("login"),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryText,
          fontWeight: FontWeight.w500,
          fontSize: 22,
        ),
      ),
    );
  }

  saveUserInSharedPreferences(SpUser spUser) async {
    await SPHelper.spHelper.setUserCredintials(
        isAdmin: spUser.isAdmin,
        isCustomer: spUser.isCustomer,
        isMarket: spUser.isMarket,
        userId: spUser.userId);
    try {} catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: 'internal_server_error', titleKey: 'alert');
    }
  }

  final GlobalKey<FormState> loginFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  height: 300.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/logo.png"))),
                  child: Container()),
              Container(
                padding: EdgeInsets.only(left: 20.w, top: 15.h, right: 20.w),
                child: Form(
                  key: loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _loginLabel(context),
                      _userNameField(),
                      _passwordField(),
                    ],
                  ),
                ),
              ),
              _loginButton(),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkUsername() async {
    final mFormData = loginFormKey.currentState;
    if (!mFormData.validate()) {
      return;
    }

    mFormData.save();

    try {
      String username = this.userName.trim().toLowerCase();
      String password = this.password.trim();
      if (ConnectivityService.connectivityStatus !=
          ConnectivityStatus.Offline) {
        AppUser user = await RegistrationClient.registrationIntance
            .loginToApp(username, password);

        if (!user.isNull) {
          signInGetx.pr.hide();
          if (user.isMarket) {
            signInGetx.setUserType(userType.market);
            appGet.setMarketId(user.userId);
            appGet.setAppUser(user);
            appGet.getMarketProducts(user.userId);
            Get.off(MarketPage(user));

            Get.off(MarketPage(user));
          } else if (user.isCustomer) {
            signInGetx.setUserType(userType.customer);
            appGet.setAppUser(user);
            Get.off(MainPage());
          } else {
            signInGetx.setUserType(userType.admin);
            appGet.setAppUser(user);
            Get.off(MainPage());
          }
        }
      } else {
        CustomDialougs.utils
            .showDialoug(messageKey: 'network_error', titleKey: 'alert');
      }
    } catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: 'e.toString()', titleKey: 'alert');
    }
  }

  Widget _userNameField() {
    return MyTextField(
      hintTextKey: 'user_name',
      nofLines: 1,
      saveFunction: saveUserName,
      validateFunction: validateEmailFunction,
    );
  }

  Widget _passwordField() {
    return MyTextField(
      hintTextKey: 'password',
      nofLines: 1,
      saveFunction: savePassword,
      validateFunction: validatepasswordFunction,
    );
  }

  Widget _loginButton() {
    return Container(
      padding: EdgeInsets.only(left: 20.w, top: 15.h, right: 20.w),
      child: PrimaryButton(
        color: AppColors.primaryColor,
        textKey: 'login',
        buttonPressFun: checkUsername,
      ),
    );
  }

  registerButtonFunction() {
    FocusScope.of(context).unfocus();
    Get.to(RegistrationOptionsPage());
  }

  Widget _registerButton() {
    return Container(
      padding: EdgeInsets.only(left: 20.w, top: 15.h, right: 20.w),
      child: PrimaryButton(
        color: Colors.black.withOpacity(0.65),
        textKey: 'register',
        buttonPressFun: registerButtonFunction,
      ),
    );
  }
}
