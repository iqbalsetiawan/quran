import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran/app/constants/color.dart';

class HomeController extends GetxController {
  RxBool isDarkMode = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    bool? storedTheme = box.read('themeDark');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isDarkMode.value = storedTheme ?? false;
      Get.changeTheme(isDarkMode.value ? themeDark : themeLight);
    });
  }

  void toggleDarkMode() {
    isDarkMode.toggle();
    Get.changeTheme(isDarkMode.value ? themeDark : themeLight);
    box.write('themeDark', isDarkMode.value);
  }
}
