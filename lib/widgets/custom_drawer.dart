import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/contact_us_page.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/about_app/about_app.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/main_control_page.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/terms_and_conditions/terms.dart';
import 'package:mashatel/features/customers/ui/pages/main_page.dart';
import 'package:mashatel/features/customers/ui/pages/market_page.dart';
import 'package:mashatel/features/messanger/ui/pages/chats.dart';
import 'package:mashatel/features/messanger/ui/pages/massenger.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';
import 'package:mashatel/features/sign_in/ui/pages/market_edit_profile.dart';
import 'package:mashatel/services/shared_prefrences_helper.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/values/radii.dart';
import 'package:mashatel/values/styles.dart';
import 'package:mashatel/welcome_page.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class AppSettings extends StatefulWidget {
  final AppUser appUser;
  AppSettings(this.appUser);
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  AppGet appGet = Get.put(AppGet());
  List<bool> isSelected = [true, false];
  String c = 'nasser';
  setIsSelectedList() async {
    String lang = await SPHelper.spHelper.getLanguage();
    if (lang == 'ar') {
      setState(() {
        isSelected = [true, false];
      });
    } else {
      setState(() {
        isSelected = [false, true];
      });
    }
  }

  @override
  void initState() {
    // isSelected = [true, false];
    setIsSelectedList();
    super.initState();
  }

  whatsAppMessnger() async {
    var phone = widget.appUser.phoneNumber;
    var whatsappUrl = "";
    if (Platform.isIOS) {
      whatsappUrl = "whatsapp://wa.me/$phone}";
    } else {
      whatsappUrl = "whatsapp://send?phone=$phone}";
    }
    await UrlLauncher.canLaunch(whatsappUrl)
        ? UrlLauncher.launch(whatsappUrl)
        : CustomDialougs.utils.showDialoug(
            messageKey: 'whats_app_not_installed', titleKey: 'alert');
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: firebaseAuth.currentUser != null
          ? Container(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                      currentAccountPicture: widget.appUser.imagePath != null
                          ? CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                widget.appUser.imagePath,
                              ),
                              child: Container(),
                            )
                          : CircleAvatar(
                              child: Text(widget.appUser != null
                                  ? appGet.appUser.value.userName[0]
                                      .toUpperCase()
                                  : ''),
                            ),
                      accountName: Text(widget.appUser.userName),
                      accountEmail: Text(widget.appUser.email)),
                  Expanded(
                    child: SettingsList(
                      backgroundColor: Colors.transparent,
                      sections: [
                        SettingsSection(
                          title: translator.translate('important_settings'),
                          titleTextStyle: Styles.titleTextStyle,
                          tiles: [
                            SettingsTile(
                              onTap: () {
                                Get.to(MainPage());
                              },
                              title: translator.translate('home'),
                              leading: Icon(Icons.home,
                                  color: AppColors.primaryColor),
                              trailing: Icon(Icons.arrow_right,
                                  color: AppColors.primaryColor),
                            ),
                            SettingsTile(
                                title: translator.translate('language'),
                                leading: Icon(Icons.language,
                                    color: AppColors.primaryColor),
                                trailing: Container(
                                  height: 45.h,
                                  child: ToggleButtons(
                                    borderColor: AppColors.primaryColor,
                                    fillColor: AppColors.primaryColor,
                                    borderWidth: 2,
                                    selectedBorderColor: AppColors.primaryColor,
                                    selectedColor: Colors.white,
                                    borderRadius: Radii.k8pxRadius,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          translator.translate('arabic'),
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          translator.translate('english'),
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                    ],
                                    onPressed: (int index) {
                                      print(index);
                                      if (index == 0) {
                                        SPHelper.spHelper.setLanguage('ar');

                                        setState(() {
                                          isSelected[0] = true;
                                          isSelected[1] = false;
                                        });

                                        translator.setNewLanguage(
                                          context,
                                          newLanguage: 'ar',
                                          restart: true,
                                          remember: true,
                                        );
                                      } else {
                                        SPHelper.spHelper.setLanguage('en');
                                        setState(() {
                                          isSelected[0] = false;
                                          isSelected[1] = true;
                                        });

                                        translator.setNewLanguage(
                                          context,
                                          newLanguage: 'en',
                                          restart: true,
                                          remember: true,
                                        );
                                      }
                                    },
                                    isSelected: isSelected,
                                  ),
                                )),
                            //////////////////////////////////////////////////
                            widget.appUser.isAdmin == false
                                ? SettingsTile(
                                    onTap: () {
                                      Get.to(ChatsPage());
                                    },
                                    title: translator.translate('messages'),
                                    leading: Icon(Icons.email,
                                        color: AppColors.primaryColor),
                                    trailing: Icon(Icons.arrow_right,
                                        color: AppColors.primaryColor),
                                  )
                                : SettingsTile(
                                    onTap: () {
                                      Get.to(ControlPanelPage());
                                    },
                                    title:
                                        translator.translate('control_panel'),
                                    leading: Icon(
                                      Icons.settings,
                                      color: AppColors.primaryColor,
                                    ),
                                    trailing: Icon(Icons.arrow_right,
                                        color: AppColors.primaryColor),
                                  ),

                            //////////////////////////////////////////////////
                            widget.appUser.isMarket == true
                                ? SettingsTile(
                                    onTap: () {
                                      Get.to(EditMarketProfilePage(
                                        appUser: widget.appUser,
                                      ));
                                    },
                                    title: translator.translate('edit_profile'),
                                    leading: Icon(
                                      Icons.shopping_cart,
                                      color: AppColors.primaryColor,
                                    ),
                                    trailing: Icon(Icons.arrow_right,
                                        color: AppColors.primaryColor),
                                  )
                                : SettingsTile(
                                    onTap: () {
                                      Get.to(ContactUsPage());
                                    },
                                    title: translator.translate('contact_us'),
                                    leading: Icon(
                                      Icons.call,
                                      color: AppColors.primaryColor,
                                    ),
                                    trailing: Icon(Icons.arrow_right,
                                        color: AppColors.primaryColor),
                                  ),
                            /////////////////////////////////////////////////
                          ],
                        ),
                        //////////////////////////////////////////////////////////////

                        SettingsSection(
                          titleTextStyle: Styles.titleTextStyle,
                          title: translator.translate('app_data'),
                          tiles: [
                            SettingsTile(
                              onTap: () {
                                Get.to(AboutApp());
                              },
                              title: translator.translate('About_app'),
                              leading: Icon(
                                FontAwesomeIcons.infoCircle,
                                color: AppColors.primaryColor,
                              ),
                              trailing: Icon(Icons.arrow_right,
                                  color: AppColors.primaryColor),
                            ),
                            SettingsTile(
                              onTap: () {
                                Get.to(TermsPage());
                              },
                              title: translator.translate('conditions'),
                              leading: Icon(
                                FontAwesomeIcons.gavel,
                                color: AppColors.primaryColor,
                              ),
                              trailing: Icon(Icons.arrow_right,
                                  color: AppColors.primaryColor),
                            ),
                          ],
                        ),
                        /////////////////////////
                        SettingsSection(
                          titleTextStyle: Styles.titleTextStyle,
                          title: translator.translate('signout'),
                          tiles: [
                            SettingsTile(
                              onTap: () {
                                RegistrationClient.registrationIntance
                                    .signOut();
                              },
                              title: translator.translate('signout'),
                              leading: Icon(
                                FontAwesomeIcons.signOutAlt,
                                color: AppColors.primaryColor,
                              ),
                              trailing: Icon(Icons.arrow_right,
                                  color: AppColors.primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                      accountName: Text('Guest'),
                      accountEmail: Text('No Email')),
                  Expanded(
                    child: SettingsList(
                      backgroundColor: Colors.transparent,
                      sections: [
                        SettingsSection(
                          title: translator.translate('important_settings'),
                          titleTextStyle: Styles.titleTextStyle,
                          tiles: [
                            SettingsTile(
                              onTap: () {
                                Get.to(MainPage());
                              },
                              title: translator.translate('home'),
                              leading: Icon(Icons.home,
                                  color: AppColors.primaryColor),
                              trailing: Icon(Icons.arrow_right,
                                  color: AppColors.primaryColor),
                            ),
                            SettingsTile(
                                title: translator.translate('language'),
                                leading: Icon(Icons.language,
                                    color: AppColors.primaryColor),
                                trailing: Container(
                                  height: 45.h,
                                  child: ToggleButtons(
                                    borderColor: AppColors.primaryColor,
                                    fillColor: AppColors.primaryColor,
                                    borderWidth: 2,
                                    selectedBorderColor: AppColors.primaryColor,
                                    selectedColor: Colors.white,
                                    borderRadius: Radii.k8pxRadius,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          translator.translate('arabic'),
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          translator.translate('english'),
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                    ],
                                    onPressed: (int index) {
                                      print(index);
                                      if (index == 0) {
                                        SPHelper.spHelper.setLanguage('ar');

                                        setState(() {
                                          isSelected[0] = true;
                                          isSelected[1] = false;
                                        });

                                        translator.setNewLanguage(
                                          context,
                                          newLanguage: 'ar',
                                          restart: true,
                                          remember: true,
                                        );
                                      } else {
                                        SPHelper.spHelper.setLanguage('en');
                                        setState(() {
                                          isSelected[0] = false;
                                          isSelected[1] = true;
                                        });

                                        translator.setNewLanguage(
                                          context,
                                          newLanguage: 'en',
                                          restart: true,
                                          remember: true,
                                        );
                                      }
                                    },
                                    isSelected: isSelected,
                                  ),
                                )),
                            //////////////////////////////////////////////////

                            /////////////////////////////////////////////////
                          ],
                        ),
                        //////////////////////////////////////////////////////////////

                        SettingsSection(
                          titleTextStyle: Styles.titleTextStyle,
                          title: translator.translate('app_data'),
                          tiles: [
                            SettingsTile(
                              onTap: () {
                                Get.to(AboutApp());
                              },
                              title: translator.translate('About_app'),
                              leading: Icon(
                                FontAwesomeIcons.infoCircle,
                                color: AppColors.primaryColor,
                              ),
                              trailing: Icon(Icons.arrow_right,
                                  color: AppColors.primaryColor),
                            ),
                            SettingsTile(
                              onTap: () {
                                Get.to(TermsPage());
                              },
                              title: translator.translate('conditions'),
                              leading: Icon(
                                FontAwesomeIcons.gavel,
                                color: AppColors.primaryColor,
                              ),
                              trailing: Icon(Icons.arrow_right,
                                  color: AppColors.primaryColor),
                            ),
                          ],
                        ),
                        /////////////////////////
                        SettingsSection(
                          titleTextStyle: Styles.titleTextStyle,
                          title: translator.translate('login'),
                          tiles: [
                            SettingsTile(
                              onTap: () {
                                Get.to(WelcomePage());
                              },
                              title: translator.translate('login'),
                              leading: Icon(
                                FontAwesomeIcons.signOutAlt,
                                color: AppColors.primaryColor,
                              ),
                              trailing: Icon(Icons.arrow_right,
                                  color: AppColors.primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
