import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/controllers/language_controller.dart';
import 'package:quran/app/routes/app_pages.dart';
import 'package:quran/app/data/models/surah.dart';
import 'package:quran/app/modules/quran/controllers/quran_controller.dart';
import 'package:quran/app/modules/home/controllers/home_controller.dart';

class SurahTabView extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final LanguageController languageController = Get.find<LanguageController>();

  SurahTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranController>(
      builder: (c) {
        return FutureBuilder<List<Surah>>(
          future: c.getAllSurah(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'error_try_again'.tr,
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('no_data'.tr));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Surah surah = snapshot.data![index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  title: Text(
                    '${surah.name?.transliteration?.id}',
                  ),
                  subtitle: Obx(() => Text(
                        '${languageController.currentLanguage.value == 'id_ID' ? surah.revelation?.id : surah.revelation?.en} | ${surah.numberOfVerses} ${'ayat'.tr}',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      )),
                  leading: Obx(() {
                    return Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            controller.isDarkMode.isTrue
                                ? 'assets/images/octagonal_dark.png'
                                : 'assets/images/octagonal_light.png',
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${surah.number}',
                        ),
                      ),
                    );
                  }),
                  trailing: Text(
                    '${surah.name?.short}',
                  ),
                  onTap: () {
                    Get.toNamed(
                      Routes.DETAIL_SURAH,
                      arguments: {
                        "name": surah.name?.transliteration?.id,
                        "number": surah.number,
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
