import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/modles/complaint_model.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/services/connectvity_service.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/widgets/TextField.dart';
import 'package:mashatel/widgets/custom_appbar.dart';
import 'package:mashatel/widgets/custom_drawer.dart';
import 'package:mashatel/widgets/primary_button.dart';
import 'package:string_validator/string_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  GlobalKey<FormState> complainKey = GlobalKey();
  AppGet appGet = Get.put(AppGet());
  String title;

  String content;

  String email;

  String phoneNumber;

  saveTitle(String title) {
    this.title = title;
  }

  saveConent(String content) {
    this.content = content;
  }

  saveEmal(String email) {
    this.email = email;
  }

  savePhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  nullValidation(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    }
  }

  validateEmailFunction(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    } else if (!isEmail(value)) {
      return translator.translate('email_error');
    }
  }

  saveForm() async {
    if (complainKey.currentState.validate()) {
      complainKey.currentState.save();
      if (ConnectivityService.connectivityStatus !=
          ConnectivityStatus.Offline) {
        ComplaintModel complaintModel = ComplaintModel(
            complaintContent: this.content,
            complaintTitle: this.title,
            email: this.email,
            mobileNumber: this.phoneNumber);
        String complaintId =
            await MashatelClient.mashatelClient.addComplaint(complaintModel);
        if (complaintId != null) {
          CustomDialougs.utils
              .showSackbar(messageKey: 'message_sent', titleKey: 'success');
          Future.delayed(Duration(seconds: 3)).then((value) => Get.back());
        } else {
          CustomDialougs.utils
              .showSackbar(messageKey: 'failed_message', titleKey: 'faild');
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
    // TODO: implement build
    return Scaffold(
      appBar: BaseAppbar('contact_us'),
      drawer: AppSettings(appGet.appUser.value),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Form(
          key: complainKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyTextField(
                  hintTextKey: 'email',
                  nofLines: 1,
                  saveFunction: saveEmal,
                  validateFunction: validateEmailFunction,
                ),
                MyTextField(
                    hintTextKey: 'tel_number',
                    nofLines: 1,
                    saveFunction: savePhoneNumber,
                    validateFunction: nullValidation),
                MyTextField(
                  hintTextKey: 'complaint_title',
                  nofLines: 1,
                  saveFunction: saveTitle,
                  validateFunction: nullValidation,
                ),
                MyTextField(
                  hintTextKey: 'complaint_content',
                  nofLines: 5,
                  saveFunction: saveConent,
                  validateFunction: nullValidation,
                ),
                PrimaryButton(
                    color: AppColors.primaryColor,
                    textKey: 'add',
                    buttonPressFun: saveForm)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
