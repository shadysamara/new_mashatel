import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CustomDialougs {
  CustomDialougs._();
  static CustomDialougs utils = CustomDialougs._();
  showDialoug({String titleKey, String messageKey}) {
    Get.defaultDialog(
        confirm: CupertinoButton(
            child: Text('Ok'),
            onPressed: () {
              print('ok');
              Get.back();
            }),
        middleText: translator.translate(messageKey),
        title: translator.translate(titleKey));
  }

  showSackbar({String titleKey, String messageKey}) {
    Get.snackbar(
      translator.translate(titleKey),
      translator.translate(messageKey),
      duration: Duration(seconds: 3),
    );
  }
}
