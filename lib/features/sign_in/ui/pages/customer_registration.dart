import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mashatel/features/sign_in/models/customer_model.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';
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

  String? userName;

  String? password;

  String? phoneNumber;

  String? email;
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
      return 'null_error'.tr;
    } else if (value.length < 8) {
      return 'password_error'.tr;
    }
  }

  validateEmailFunction(String value) {
    if (value.isEmpty) {
      return 'null_error'.tr;
    } else if (!isEmail(value)) {
      return 'email_error'.tr;
    }
  }

  nullValidation(String value) {
    if (value.isEmpty) {
      return 'null_error'.tr;
    }
  }

  saveForm() async {
    if (customerRegFormKey.currentState?.validate() == true) {
      customerRegFormKey.currentState?.save();
      AppUser customer = AppUser(
          userName: this.userName,
          phoneNumber: this.phoneNumber,
          email: this.email,
          password: this.password);
      if (ConnectivityService.connectivityStatus !=
          ConnectivityStatus.Offline) {
        signInGetx.pr.show();
        String? id = await RegistrationClient.registrationIntance
            .registerAsCustomer(customer);
        if (!id.isNull) {
          signInGetx.pr.hide();
          Get.snackbar(
            'market_snackbar_title'.tr,
            'customer_snackbar_message'.tr,
            duration: Duration(seconds: 3),
          );
          signInGetx.setUserType(UserType.customer);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('customers_register'.tr),
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
                          'customers_register'.tr,
                          style: Styles.titleTextStyle,
                        ),
                      ],
                    ),
                    subtitle: Text(
                      'customers_register_note'.tr,
                      style: Styles.subTitleTextStyle,
                    ),
                  ),
                  MyTextField(
                    hintTextKey: 'user_name'.tr,
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
                    hintTextKey: 'password'.tr,
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
                    onPressed: saveForm,
                    textKey: 'register'.tr,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
