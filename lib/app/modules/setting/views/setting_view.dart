import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/views/base_view.dart';
import 'package:quran/app/modules/home/controllers/home_controller.dart';

class SettingView extends BaseView {
  const SettingView({super.key});

  @override
  String get appBarTitle => 'Pengaturan';

  @override
  Widget get body {
    final homeController = Get.find<HomeController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tampilan',
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
                'Mode Gelap',
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
        ],
      ),
    );
  }
}
