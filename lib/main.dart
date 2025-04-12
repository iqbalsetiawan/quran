import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/constants/color.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();

  bool isFirstLaunch = box.read('isFirstLaunch') ?? true;
  if (isFirstLaunch) {
    await box.write('isFirstLaunch', false);
  }

  bool isDark = box.read('themeDark') ?? false;

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? themeDark : themeLight,
      themeMode: ThemeMode.light,
      title: "Application",
      initialRoute: isFirstLaunch ? Routes.INTRODUCTION : Routes.HOME,
      getPages: AppPages.routes,
    ),
  );
}
