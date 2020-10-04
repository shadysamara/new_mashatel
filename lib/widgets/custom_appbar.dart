import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/new_product.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';

class BaseAppbar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  BaseAppbar(this.title);
  AppGet appGet = Get.put(AppGet());
  SignInGetx signInGetx = Get.put(SignInGetx());
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: new IconThemeData(color: Colors.white),
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
      automaticallyImplyLeading: true,
      elevation: 0,
      actions: [
        signInGetx.usertype.value != userType.market
            ? Container()
            : IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.to(NewProduct(appGet.marketId.value));
                }),
        IconButton(
            icon: Icon(
              FontAwesomeIcons.signOutAlt,
              color: Colors.white,
            ),
            onPressed: () {
              RegistrationClient.registrationIntance.signOut();
            })
      ],
      title: Text(translator.translate(title)),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
