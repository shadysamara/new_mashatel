import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/market_page.dart';
import 'package:mashatel/features/sign_in/models/market_model.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';
import 'package:mashatel/features/sign_in/ui/pages/market_location_page.dart';
import 'package:mashatel/features/sign_in/ui/pages/testpage.dart';
import 'package:mashatel/features/sign_in/ui/widgets/custom_dropdown.dart';
import 'package:mashatel/features/sign_in/ui/widgets/upload_file.dart';
import 'package:mashatel/services/auth.dart';
import 'package:mashatel/services/connectvity_service.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/values/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/values/values.dart';
import 'package:mashatel/widgets/TextField.dart';
import 'package:mashatel/widgets/primary_button.dart';
import 'package:string_validator/string_validator.dart';

class MarketRegistrationPage extends StatefulWidget {
  @override
  _MarketRegistrationPageState createState() => _MarketRegistrationPageState();
}

class _MarketRegistrationPageState extends State<MarketRegistrationPage> {
  GlobalKey<FormState> marketRegFormKey = GlobalKey();

  String companyName;

  String userName;

  String password;

  String email;

  String phoneNumber;

  File marketLogo;

  String comapnyActivity;

  final SignInGetx signInGetx = Get.put(SignInGetx());
  final AppGet appGet = Get.put(AppGet());

  saveCompanyName(String value) {
    this.companyName = value;
    signInGetx.companyName = value;
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

  saveForm() async {
    if (marketRegFormKey.currentState.validate()) {
      if (signInGetx.file != null) {
        if (signInGetx.positionIsMarkes.value == true) {
          if (signInGetx.category != null) {
            marketRegFormKey.currentState.save();
            AppUser market = AppUser(
                comapnyActivity: this.comapnyActivity,
                companyName: this.companyName,
                email: this.email,
                marketLogo: signInGetx.file,
                password: this.password,
                phoneNumber: this.phoneNumber,
                lat: signInGetx.position.value.latitude,
                lon: signInGetx.position.value.longitude,
                catId: signInGetx.category.catId,
                userName: this.userName);
            if (ConnectivityService.connectivityStatus !=
                ConnectivityStatus.Offline) {
              signInGetx.pr.show();
              AppUser appUser = await RegistrationClient.registrationIntance
                  .registerAsMarket(market);
              if (!appUser.isNull) {
                signInGetx.pr.hide();
                CustomDialougs.utils.showSackbar(
                    messageKey: 'market_snackbar_message',
                    titleKey: 'market_snackbar_title');
                signInGetx.setUserType(userType.market);
                appGet.setMarketId(appUser.userId);

                Get.off(MarketPage(appUser));
              }
            } else {
              CustomDialougs.utils
                  .showDialoug(messageKey: 'network_error', titleKey: 'alert');
            }
          } else {
            CustomDialougs.utils.showDialoug(
                messageKey: 'missing_category', titleKey: 'missing_element');
          }
        } else {
          CustomDialougs.utils.showDialoug(
              messageKey: 'market_location_error', titleKey: 'missing_element');
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
        title: Text(translator.translate('market_register')),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: Form(
            key: marketRegFormKey,
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
                          translator.translate('market_register'),
                          style: Styles.titleTextStyle,
                        ),
                      ],
                    ),
                    subtitle: Text(
                      translator.translate('market_register_note'),
                      style: Styles.subTitleTextStyle,
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
                      onTap: () {
                        Get.to(MarkertLocationCollecter());
                      },
                      leading: Icon(
                        Icons.location_on,
                        color: AppColors.primaryColor,
                      ),
                      title: Obx(() => signInGetx.poitinAsString.value.isEmpty
                          ? Text(translator.translate('company_location'))
                          : Text(signInGetx.poitinAsString.value))),
                  MyTextField(
                    hintTextKey: 'tel_number',
                    nofLines: 1,
                    validateFunction: nullValidation,
                    saveFunction: savephoneNumber,
                    textInputType: TextInputType.phone,
                  ),
                  uploadFile(),
                  SizedBox(
                    height: 20.h,
                  ),
                  MyTextField(
                    hintTextKey: 'company_activity',
                    nofLines: 1,
                    validateFunction: nullValidation,
                    saveFunction: savecomapnyActivity,
                  ),
                  CategoriesDropDown(),
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
