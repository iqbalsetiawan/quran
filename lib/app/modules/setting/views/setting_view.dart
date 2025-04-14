import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/views/base_view.dart';
import 'package:quran/app/modules/home/controllers/home_controller.dart';
import 'package:quran/app/controllers/language_controller.dart';

class SettingView extends BaseView {
  const SettingView({super.key});

  @override
  String get appBarTitle => 'setting'.tr;

  @override
  Widget get body {
    final homeController = Get.find<HomeController>();
    final languageController = Get.find<LanguageController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'appearance'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            child: ListTile(
              leading: const Icon(
                Icons.dark_mode,
                size: 28,
              ),
              title: Text(
                'dark_mode'.tr,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              trailing: Obx(
                () => Switch(
                  value: homeController.isDarkMode.value,
                  onChanged: (value) {
                    homeController.toggleDarkMode();
                  },
                  trackColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.green;
                    }
                    return Colors.grey;
                  }),
                  thumbColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white;
                    }
                    return Colors.white;
                  }),
                  trackOutlineColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'language'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            child: ListTile(
              leading: const Icon(
                Icons.language,
                size: 28,
              ),
              title: Text(
                'app_language'.tr,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
              subtitle: Obx(
                () => Text(
                  languageController.currentLanguage.value == 'id_ID'
                      ? 'Indonesia'
                      : 'English',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ),
              onTap: () {
                _showLanguageDialog(languageController);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(LanguageController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('select_language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Indonesia'),
              leading: Obx(() => Radio<String>(
                    value: 'id_ID',
                    groupValue: controller.currentLanguage.value,
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateLocale(value);
                        Get.back();
                      }
                    },
                  )),
            ),
            ListTile(
              title: const Text('English'),
              leading: Obx(() => Radio<String>(
                    value: 'en_US',
                    groupValue: controller.currentLanguage.value,
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateLocale(value);
                        Get.back();
                      }
                    },
                  )),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('cancel'.tr),
          ),
        ],
      ),
    );
  }
}
