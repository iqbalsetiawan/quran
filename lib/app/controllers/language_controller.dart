import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final box = GetStorage();

  final RxString currentLanguage = 'id_ID'.obs;

  @override
  void onInit() {
    super.onInit();
    String? storedLanguage = box.read('language');
    if (storedLanguage != null) {
      currentLanguage.value = storedLanguage;
      // Apply locale without showing dialog during initialization
      final locale =
          Locale(storedLanguage.split('_')[0], storedLanguage.split('_')[1]);
      Get.updateLocale(locale);
    }
  }

  void updateLocale(String languageCode) {
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    Future.delayed(Duration(milliseconds: 300), () {
      final locale =
          Locale(languageCode.split('_')[0], languageCode.split('_')[1]);
      Get.updateLocale(locale);
      box.write('language', languageCode);
      currentLanguage.value = languageCode;

      Get.back();
    });
  }

  void toggleLanguage() {
    final newLanguage = currentLanguage.value == 'id_ID' ? 'en_US' : 'id_ID';
    updateLocale(newLanguage);
  }

  String get currentLanguageName =>
      currentLanguage.value == 'id_ID' ? 'Indonesia' : 'English';
}
