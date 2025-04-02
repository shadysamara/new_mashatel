import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/add_product.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';

class BaseAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  BaseAppbar(this.title);
  final AppGet appGet = Get.put(AppGet());
  final SignInGetx signInGetx = Get.put(SignInGetx());
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: new IconThemeData(color: Colors.white),
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
      automaticallyImplyLeading: true,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Container(
                  child: Text(
            translator.translate(title),
            textAlign: TextAlign.center,
          ))),
          signInGetx.usertype.value != userType.market
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.to(AddNewProduct());
                  }),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
