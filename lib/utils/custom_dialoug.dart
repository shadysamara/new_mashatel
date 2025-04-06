import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomDialougs {
  CustomDialougs._();
  static CustomDialougs utils = CustomDialougs._();
  showDialoug(
      {required String titleKey,
      required String messageKey,
      Function? function}) {
    Get.defaultDialog(
        confirm: CupertinoButton(
            child: Text('Ok'),
            onPressed: () {
              print('ok');
              function == null ? Get.back() : function();
            }),
        middleText: messageKey.tr,
        title: titleKey.tr);
  }

  showSackbar({required String titleKey, required String messageKey}) {
    Get.snackbar(
      titleKey.tr,
      messageKey.tr,
      duration: Duration(seconds: 3),
    );
  }
}
