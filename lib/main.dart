import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran/app/translation/app_translations.dart';

import 'app/constants/color.dart';
import 'app/routes/app_pages.dart';
import 'app/controllers/language_controller.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();

  bool isDark = box.read('themeDark') ?? false;
  String language = box.read('language') ?? 'id_ID';

  Get.put(LanguageController());

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? themeDark : themeLight,
      themeMode: ThemeMode.light,
      title: "Application",
      initialRoute: Routes.INTRODUCTION,
      getPages: AppPages.routes,
      locale: Locale(language.split('_')[0], language.split('_')[1]),
      fallbackLocale: const Locale('id', 'ID'),
      translations: AppTranslations(),
    ),
  );
}
