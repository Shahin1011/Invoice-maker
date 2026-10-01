import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController implements Listenable {
  Locale _locale = const Locale('en', 'US');

  Locale get locale => _locale;

  void setLanguage(Locale locale) {
    _locale = locale;
    Get.updateLocale(locale);
    update();
  }
}
