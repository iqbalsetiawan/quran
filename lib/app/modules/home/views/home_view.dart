import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/modules/quran/quran.dart';
import 'package:quran/app/modules/hadis/views/hadis_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxInt currentIndex = 0.obs;

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: currentIndex.value,
          children: const [
            Quran(),
            HadisView(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Quran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Hadis',
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
