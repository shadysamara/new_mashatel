import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mashatel/services/shared_prefrences_helper.dart';
import 'package:mashatel/translations/ar.dart';
import 'package:mashatel/translations/en.dart';

enum Language { en, ar }

class LocalizationService extends Translations {
  // static Lan getRightContent({String arabicChoise, String englishChoise}) {
  //   return Get.locale == Locale('ar', 'SA') ? arabicChoise : englishChoise;
  // }

  // Default locale
  static setLocale(Language lan) {
    SPHelper.spHelper.setLanguage(lan == Language.ar ? 'ar' : 'en');
  }

  // static final locale = Locale('en', 'US');
  static Locale getSavedLocal() {
    Language lan =
        SPHelper.spHelper.getLanguage() == "en" ? Language.en : Language.ar;
    log("the saved language enum is ${SPHelper.spHelper.getLanguage()}");
    log("the saved language enum is ${lan.toString()}");
    if (lan == Language.en) {
      return const Locale('en');
    } else {
      return const Locale('ar');
    }
  }

  static bool isArabic() {
    return SPHelper.spHelper.getLanguage() == "ar";
  }

  // fallbackLocale saves the day when the locale gets in trouble
  static const fallbackLocale = Locale('ar');

  static final langs = ['English', 'Arabic'];

  static final locales = [
    const Locale('en'),
    const Locale('ar'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en': enUS, // lang/en_us.dart
        'ar': arSA, // lang/tr_tr.dart
      };

  // Gets locale from language, and updates the locale
  static changeLocale(Language lan) {
    Locale locale;
    if (lan == Language.ar) {
      locale = const Locale('ar');
    } else {
      locale = const Locale('en');
    }
    setLocale(lan);
    Get.updateLocale(locale);
  }
}
