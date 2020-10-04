import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class HandleFirebaseErrorMessages {
  static void showErrorMessage(dynamic e) {
    String errorMessage;
    print('error message  :  ${e.message}');
    print('error code  :   ${e.code}');
    // if (Platform.isAndroid) {
    switch (e.message) {
      case "There is no user record corresponding to this identifier. The user may have been deleted.":
        errorMessage = translator.translate("user_not_found_or_deleted");
        break;
      case "The password is invalid or the user does not have a password.":
        errorMessage = translator.translate("login_password_invalid");
        break;
      case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
        errorMessage = translator.translate("network_error_fb");
        break;
      case "The email address is already in use by another account.":
        errorMessage = translator.translate("email_already_in_use");
        break;
      case "The given password is invalid.":
        errorMessage = translator.translate("weak_password");
        break;
      case "We have blocked all requests from this device due to unusual activity. Try again later.":
        errorMessage = translator.translate("blocked_requests");
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
        title: translator.translate('alert'));
  }
}
