import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/contact_us_page.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/about_app/about_app.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/main_control_page.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/terms_and_conditions/terms.dart';
import 'package:mashatel/features/customers/ui/pages/main_page.dart';
import 'package:mashatel/features/messanger/ui/pages/chats.dart';
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
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AppSettings extends StatefulWidget {
  final AppUser appUser;

  const AppSettings(this.appUser);

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  final AppGet appGet = Get.put(AppGet());
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = [true, false]; // Default to Arabic
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final lang = await SPHelper.spHelper.getLanguage();
    setState(() {
      _isSelected = lang == 'ar' ? [true, false] : [false, true];
    });
  }

  Future<void> _launchWhatsApp() async {
    final phone = widget.appUser.phoneNumber;
    if (phone == null) return;

    final whatsappUrl = Platform.isIOS
        ? 'whatsapp://wa.me/$phone'
        : 'whatsapp://send?phone=$phone';

    try {
      final uri = Uri.parse(whatsappUrl);
      if (await url_launcher.canLaunchUrl(uri)) {
        await url_launcher.launchUrl(uri);
      } else {
        if (mounted) {
          CustomDialougs.utils.showDialoug(
            messageKey: 'whats_app_not_installed',
            titleKey: 'alert',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomDialougs.utils.showDialoug(
          messageKey: 'error_launching_whatsapp',
          titleKey: 'alert',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = _firebaseAuth.currentUser != null;

    return Drawer(
      child: Column(
        children: [
          _buildHeader(isLoggedIn),
          Expanded(
            child: SettingsList(
              contentPadding: EdgeInsets.zero,
              platform: DevicePlatform.android,
              sections: [
                _buildImportantSettingsSection(isLoggedIn),
                _buildAppDataSection(),
                _buildAuthSection(isLoggedIn),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isLoggedIn) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: AppColors.primaryColor),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: widget.appUser.imagePath != null &&
                widget.appUser.imagePath!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: widget.appUser.imagePath!,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Text(
                  widget.appUser.userName?.isNotEmpty == true
                      ? widget.appUser.userName![0].toUpperCase()
                      : '',
                ),
              )
            : Text(
                widget.appUser.userName?.isNotEmpty == true
                    ? widget.appUser.userName![0].toUpperCase()
                    : '',
                style: const TextStyle(color: Colors.black),
              ),
      ),
      accountName:
          Text(isLoggedIn ? widget.appUser.userName ?? '' : 'Guest'.tr),
      accountEmail: Text(isLoggedIn ? widget.appUser.email ?? '' : 'No Email'),
    );
  }

  SettingsSection _buildImportantSettingsSection(bool isLoggedIn) {
    return SettingsSection(
      title: Text('important_settings'.tr, style: Styles.titleTextStyle),
      tiles: [
        SettingsTile.navigation(
          title: Text(
            'home'.tr,
            style: TextStyle(fontFamily: "DIN", height: 0.5),
          ),
          leading: const Icon(Icons.home, color: AppColors.primaryColor),
          trailing:
              const Icon(Icons.arrow_right, color: AppColors.primaryColor),
          onPressed: (_) => Get.to(() => MainPage()),
        ),
        SettingsTile(
          title: Text(
            'language'.tr,
            style: TextStyle(fontFamily: "DIN", height: 0.5),
          ),
          leading: const Icon(Icons.language, color: AppColors.primaryColor),
          trailing: SizedBox(
            height: 45.h,
            child: ToggleButtons(
              borderColor: AppColors.primaryColor,
              fillColor: AppColors.primaryColor,
              borderWidth: 2,
              selectedBorderColor: AppColors.primaryColor,
              selectedColor: Colors.white,
              borderRadius: Radii.k8pxRadius,
              onPressed: _handleLanguageToggle,
              isSelected: _isSelected,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('arabic'.tr, style: TextStyle(fontSize: 17)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('english'.tr, style: TextStyle(fontSize: 17)),
                ),
              ],
            ),
          ),
        ),
        if (isLoggedIn) ..._buildUserSpecificTiles(),
      ],
    );
  }

  List<SettingsTile> _buildUserSpecificTiles() {
    return [
      if (widget.appUser.isAdmin == false)
        SettingsTile.navigation(
          title: Text(
            'messages'.tr,
            style: TextStyle(fontFamily: "DIN", height: 0.5),
          ),
          leading: const Icon(Icons.email, color: AppColors.primaryColor),
          trailing:
              const Icon(Icons.arrow_right, color: AppColors.primaryColor),
          onPressed: (_) => Get.to(() => ChatsPage()),
        )
      else
        SettingsTile.navigation(
          title: Text(
            'control_panel'.tr,
            style: TextStyle(fontFamily: "DIN", height: 0.5),
          ),
          leading: const Icon(Icons.settings, color: AppColors.primaryColor),
          trailing:
              const Icon(Icons.arrow_right, color: AppColors.primaryColor),
          onPressed: (_) => Get.to(() => ControlPanelPage()),
        ),
      if (widget.appUser.isMarket == true)
        SettingsTile.navigation(
          title: Text(
            'edit_profile'.tr,
            style: TextStyle(fontFamily: "DIN", height: 0.5),
          ),
          leading:
              const Icon(Icons.shopping_cart, color: AppColors.primaryColor),
          trailing:
              const Icon(Icons.arrow_right, color: AppColors.primaryColor),
          onPressed: (_) =>
              Get.to(() => EditMarketProfilePage(appUser: widget.appUser)),
        )
      else
        SettingsTile.navigation(
          title: Text(
            'contact_us'.tr,
            style: TextStyle(fontFamily: "DIN", height: 0.5),
          ),
          leading: const Icon(Icons.call, color: AppColors.primaryColor),
          trailing:
              const Icon(Icons.arrow_right, color: AppColors.primaryColor),
          onPressed: (_) => Get.to(() => ContactUsPage()),
        ),
    ];
  }

  SettingsSection _buildAppDataSection() {
    return SettingsSection(
      title: Text('app_data'.tr, style: Styles.titleTextStyle),
      tiles: [
        SettingsTile.navigation(
          title: Text(
            'About_app'.tr,
            style: TextStyle(fontFamily: "DIN", height: 0.5),
          ),
          leading: const Icon(FontAwesomeIcons.infoCircle,
              color: AppColors.primaryColor),
          trailing:
              const Icon(Icons.arrow_right, color: AppColors.primaryColor),
          onPressed: (_) => Get.to(() => AboutApp()),
        ),
        SettingsTile.navigation(
          title: Text(
            'conditions'.tr,
            style: TextStyle(fontFamily: "DIN", height: 0.5),
          ),
          leading:
              const Icon(FontAwesomeIcons.gavel, color: AppColors.primaryColor),
          trailing:
              const Icon(Icons.arrow_right, color: AppColors.primaryColor),
          onPressed: (_) => Get.to(() => TermsPage()),
        ),
      ],
    );
  }

  SettingsSection _buildAuthSection(bool isLoggedIn) {
    return SettingsSection(
      title: Text(isLoggedIn ? 'signout'.tr : 'login'.tr,
          style: Styles.titleTextStyle),
      tiles: [
        SettingsTile.navigation(
          title: Text(
            isLoggedIn ? 'signout'.tr : 'login'.tr,
            style: TextStyle(fontFamily: "DIN", height: 0.5),
          ),
          leading: const Icon(FontAwesomeIcons.signOutAlt,
              color: AppColors.primaryColor),
          trailing:
              const Icon(Icons.arrow_right, color: AppColors.primaryColor),
          onPressed: (_) => isLoggedIn
              ? RegistrationClient.registrationIntance.signOut()
              : Get.to(() => WelcomePage()),
        ),
      ],
    );
  }

  void _handleLanguageToggle(int index) {
    setState(() {
      _isSelected = index == 0 ? [true, false] : [false, true];
    });
    final newLang = index == 0 ? 'ar' : 'en';
    SPHelper.spHelper.setLanguage(newLang);
    // Assuming 'translator' is available globally or through GetX
    // You might need to adjust this based on your actual translation implementation
    Get.updateLocale(Locale(newLang));
  }
}
