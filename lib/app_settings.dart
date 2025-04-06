import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mashatel/localization_service.dart';
import 'package:mashatel/services/shared_prefrences_helper.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/values/radii.dart';
import 'package:mashatel/values/styles.dart';
import 'package:settings_ui/settings_ui.dart';

class AppSettingsTest extends StatefulWidget {
  const AppSettingsTest({super.key});

  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettingsTest> {
  List<bool> isSelected = [true, false];

  Future<void> setIsSelectedList() async {
    final String? lang = await SPHelper.spHelper.getLanguage();
    print(lang);
    setState(() {
      if (lang == 'ar') {
        isSelected = [true, false];
      } else {
        isSelected = [false, true];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setIsSelectedList();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(392.72727272727275, 850.9090909090909),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Scaffold(
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(
              'important_settings'.tr,
              style: Styles.titleTextStyle,
            ),
            tiles: [
              SettingsTile.switchTile(
                activeSwitchColor: AppColors.primaryColor,
                title: Text('enable_notifications'.tr),
                leading: const Icon(Icons.notifications,
                    color: AppColors.primaryColor),
                initialValue: true,
                onToggle: (bool value) {},
              ),
              SettingsTile(
                title: Text('language'.tr),
                leading:
                    const Icon(Icons.language, color: AppColors.primaryColor),
                trailing: SizedBox(
                  height: 45.h,
                  child: ToggleButtons(
                    borderColor: AppColors.primaryColor,
                    fillColor: AppColors.primaryColor,
                    borderWidth: 2,
                    selectedBorderColor: AppColors.primaryColor,
                    selectedColor: Colors.white,
                    borderRadius: Radii.k8pxRadius,
                    isSelected: isSelected,
                    onPressed: (int index) {
                      print(index);
                      if (index == 0) {
                        LocalizationService.changeLocale(Language.ar);
                        setState(() {
                          isSelected[0] = true;
                          isSelected[1] = false;
                        });
                      } else {
                        LocalizationService.changeLocale(Language.en);
                        setState(() {
                          isSelected[0] = false;
                          isSelected[1] = true;
                        });
                      }
                    },
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'arabic'.tr,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'english'.tr,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SettingsTile(
                title: Text('currency'.tr),
                leading: const Icon(FontAwesomeIcons.dollarSign,
                    color: AppColors.primaryColor),
                trailing: const Icon(Icons.arrow_right,
                    color: AppColors.primaryColor),
              ),
            ],
          ),
          SettingsSection(
            title: Text(
              'About_app'.tr,
              style: Styles.titleTextStyle,
            ),
            tiles: [
              SettingsTile(
                title: Text('About_app'.tr),
                leading: const Icon(FontAwesomeIcons.infoCircle,
                    color: AppColors.primaryColor),
                trailing: const Icon(Icons.arrow_right,
                    color: AppColors.primaryColor),
              ),
              SettingsTile(
                title: Text('conditions'.tr),
                leading: const Icon(FontAwesomeIcons.gavel,
                    color: AppColors.primaryColor),
                trailing: const Icon(Icons.arrow_right,
                    color: AppColors.primaryColor),
              ),
              SettingsTile(
                title: Text('user_policy'.tr),
                leading: const Icon(FontAwesomeIcons.fileContract,
                    color: AppColors.primaryColor),
                trailing: const Icon(Icons.arrow_right,
                    color: AppColors.primaryColor),
              ),
              SettingsTile(
                title: Text('contact_us'.tr),
                leading: const Icon(FontAwesomeIcons.phoneAlt,
                    color: AppColors.primaryColor),
                trailing: const Icon(Icons.arrow_right,
                    color: AppColors.primaryColor),
              ),
              SettingsTile(
                title: Text('share_app'.tr),
                leading: const Icon(FontAwesomeIcons.shareAlt,
                    color: AppColors.primaryColor),
                trailing: const Icon(Icons.arrow_right,
                    color: AppColors.primaryColor),
              ),
              SettingsTile(
                title: Text('rate_app'.tr),
                leading: const Icon(FontAwesomeIcons.star,
                    color: AppColors.primaryColor),
                trailing: const Icon(Icons.arrow_right,
                    color: AppColors.primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
