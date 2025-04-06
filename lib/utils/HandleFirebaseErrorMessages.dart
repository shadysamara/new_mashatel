import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HandleFirebaseErrorMessages {
  static void showErrorMessage(dynamic e) {
    String errorMessage;
    print('error message  :  ${e.message}');
    print('error code  :   ${e.code}');
    // if (Platform.isAndroid) {
    switch (e.message) {
      case "There is no user record corresponding to this identifier. The user may have been deleted.":
        errorMessage = "user_not_found_or_deleted".tr;
        break;
      case "The password is invalid or the user does not have a password.":
        errorMessage = "login_password_invalid".tr;
        break;
      case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
        errorMessage = "network_error_fb".tr;
        break;
      case "The email address is already in use by another account.":
        errorMessage = "email_already_in_use".tr;
        break;
      case "The given password is invalid.":
        errorMessage = "weak_password".tr;
        break;
      case "We have blocked all requests from this device due to unusual activity. Try again later.":
        errorMessage = "blocked_requests".tr;
        break;
      default:
        errorMessage = 'Case ${e.message} is not jet implemented';
    }
    Get.defaultDialog(
        confirm: CupertinoButton(
            child: Text('Ok'),
            onPressed: () {
              print('ok');
              Get.back();
            }),
        middleText: errorMessage,
        title: 'alert'.tr);
  }
}
