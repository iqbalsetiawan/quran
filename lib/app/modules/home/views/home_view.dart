import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/modules/quran/quran.dart';
import 'package:quran/app/modules/hadis/views/hadis_view.dart';
import 'package:quran/app/modules/setting/views/setting_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxInt currentIndex = 0.obs;

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: currentIndex.value,
          children: const [Quran(), HadisView(), SettingView()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'quran'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'hadith'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'setting'.tr,
            ),
          ],
          currentIndex: currentIndex.value,
          onTap: (index) {
            currentIndex.value = index;
          },
        ),
      ),
    );
  }
}
