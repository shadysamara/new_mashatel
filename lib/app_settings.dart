import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/services/shared_prefrences_helper.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/values/radii.dart';
import 'package:mashatel/values/styles.dart';
import 'package:settings_ui/settings_ui.dart';

class AppSettingsTest extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettingsTest> {
  List<bool> isSelected = [true, false];
  String c = 'nasser';
  setIsSelectedList() async {
    String lang = await SPHelper.spHelper.getLanguage();
    print(lang);
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 392.72727272727275,
        height: 850.9090909090909,
        allowFontScaling: true);
    return Scaffold(
      body: SettingsList(
        sections: [
          SettingsSection(
            titleTextStyle: Styles.titleTextStyle,
            title: translator.translate('important_settings'),
            tiles: [
              SettingsTile.switchTile(
                switchActiveColor: AppColors.primaryColor,
                title: translator.translate('enable_notifications'),
                leading:
                    Icon(Icons.notifications, color: AppColors.primaryColor),
                switchValue: true,
                onToggle: (bool value) {},
              ),
              SettingsTile(
                  title: translator.translate('language'),
                  leading: Icon(Icons.language, color: AppColors.primaryColor),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            translator.translate('arabic'),
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  )

                  // setState(() {
                  //   this.isEnglish = !this.isEnglish;
                  //   print(this.isEnglish);
                  //   if (translator.currentLanguage == 'en') {
                  //     translator.setNewLanguage(
                  //       context,
                  //       newLanguage: 'ar',
                  //       restart: true,
                  //       remember: true,
                  //     );
                  //     this.isEnglish = false;
                  //   } else {
                  //     translator.setNewLanguage(
                  //       context,
                  //       newLanguage: 'en',
                  //       restart: true,
                  //       remember: true,
                  //     );
                  //     this.isEnglish = true;
                  //   }
                  // });
                  ),
              SettingsTile(
                title: translator.translate('currency'),
                leading: Icon(FontAwesomeIcons.dollarSign,
                    color: AppColors.primaryColor),
                trailing:
                    Icon(Icons.arrow_right, color: AppColors.primaryColor),
              ),
            ],
          ),
          //////////////////////////////////////////////////////////////
          SettingsSection(
            titleTextStyle: Styles.titleTextStyle,
            title: translator.translate('About_app'),
            tiles: [
              SettingsTile(
                title: translator.translate('About_app'),
                leading: Icon(
                  FontAwesomeIcons.infoCircle,
                  color: AppColors.primaryColor,
                ),
                trailing:
                    Icon(Icons.arrow_right, color: AppColors.primaryColor),
              ),
              SettingsTile(
                title: translator.translate('conditions'),
                leading: Icon(
                  FontAwesomeIcons.gavel,
                  color: AppColors.primaryColor,
                ),
                trailing:
                    Icon(Icons.arrow_right, color: AppColors.primaryColor),
              ),
              SettingsTile(
                title: translator.translate('user_policy'),
                leading: Icon(
                  FontAwesomeIcons.fileContract,
                  color: AppColors.primaryColor,
                ),
                trailing:
                    Icon(Icons.arrow_right, color: AppColors.primaryColor),
              ),
              SettingsTile(
                title: translator.translate('contact_us'),
                leading: Icon(
                  FontAwesomeIcons.phoneAlt,
                  color: AppColors.primaryColor,
                ),
                trailing:
                    Icon(Icons.arrow_right, color: AppColors.primaryColor),
              ),
              SettingsTile(
                title: translator.translate('share_app'),
                leading: Icon(
                  FontAwesomeIcons.shareAlt,
                  color: AppColors.primaryColor,
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  color: AppColors.primaryColor,
                ),
              ),
              SettingsTile(
                title: translator.translate('rate_app'),
                leading: Icon(
                  FontAwesomeIcons.star,
                  color: AppColors.primaryColor,
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
