import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/constants/color.dart';
import 'package:quran/app/controllers/language_controller.dart';

import 'package:quran/app/data/models/juz.dart' as juz;
import 'package:quran/app/data/models/surah.dart';
import 'package:quran/app/modules/detail_juz/controllers/detail_juz_controller.dart';
import 'package:quran/app/modules/quran/controllers/quran_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  final juz.Juz detailJuz = Get.arguments[0];
  final List<Surah> allSurahInJuz = Get.arguments[1];
  final homeController = Get.find<QuranController>();
  final languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JUZ ${detailJuz.juz}'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(20),
            itemCount: detailJuz.verses?.length ?? 0,
            itemBuilder: (context, index) {
              if (detailJuz.verses == null || detailJuz.verses!.isEmpty) {
                return Center(child: Text('no_data'.tr));
              }

              juz.Verses ayat = detailJuz.verses![index];

              int surahIndex = 0;
              for (int i = 0; i <= index; i++) {
                if (detailJuz.verses![i].number?.inSurah == 1 && i > 0) {
                  surahIndex++;
                }
              }

              if (surahIndex >= allSurahInJuz.length) {
                surahIndex = allSurahInJuz.length - 1;
              }

              return Column(
                children: [
                  Visibility(
                    visible: ayat.number?.inSurah == 1,
                    child: GestureDetector(
                      onTap: () {
                        Get.dialog(
                          Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Get.isDarkMode
                                    ? appPurpleLight2.withOpacity(0.3)
                                    : appWhite,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Tafsir',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    '${allSurahInJuz[surahIndex].tafsir?.id}',
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [appPurpleLight1, appPurpleDark],
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: -50,
                                right: 0,
                                child: Opacity(
                                  opacity: 0.7,
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(
                                      '${allSurahInJuz[surahIndex].name?.transliteration?.id?.toUpperCase()}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: appWhite,
                                      ),
                                    ),
                                    Text(
                                      '(${languageController.currentLanguage.value == 'id_ID' ? allSurahInJuz[surahIndex].name?.translation?.id?.toUpperCase() : allSurahInJuz[surahIndex].name?.translation?.en?.toUpperCase()})',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: appWhite,
                                      ),
                                    ),
                                    Divider(
                                      color: appWhite,
                                    ),
                                    Text(
                                      '${languageController.currentLanguage.value == 'id_ID' ? allSurahInJuz[surahIndex].revelation?.id : allSurahInJuz[surahIndex].revelation?.en} | ${allSurahInJuz[surahIndex].numberOfVerses} ${'ayat'.tr}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: appWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (ayat.number?.inSurah == 1 &&
                      ayat.number?.inQuran != 1 &&
                      ayat.number?.inQuran != 1236) ...[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: appPurpleLight2.withOpacity(0.3),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          Get.isDarkMode
                                              ? 'assets/images/octagonal_dark.png'
                                              : 'assets/images/octagonal_light.png',
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text('${ayat.number?.inSurah}'),
                                    ),
                                  ),
                                  Text(
                                    '${allSurahInJuz[surahIndex].name!.transliteration!.id}',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              GetBuilder<DetailJuzController>(builder: (c) {
                                return Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.bookmark_add_outlined),
                                      tooltip: 'add_bookmark'.tr,
                                      onPressed: () {
                                        Get.defaultDialog(
                                          titlePadding: EdgeInsets.only(
                                              top: 20, bottom: 10),
                                          title: 'feature_coming_soon'.tr,
                                          middleText:
                                              'feature_coming_soon_message'.tr,
                                        );
                                      },
                                    ),
                                    (ayat.audioStatus == 'stop')
                                        ? IconButton(
                                            icon: Icon(Icons.play_arrow),
                                            tooltip: 'play_audio'.tr,
                                            onPressed: () {
                                              c.playAudio(ayat);
                                            },
                                          )
                                        : Row(
                                            children: [
                                              (ayat.audioStatus == 'play')
                                                  ? IconButton(
                                                      icon: Icon(Icons.pause),
                                                      tooltip: 'pause_audio'.tr,
                                                      onPressed: () {
                                                        c.pauseAudio(ayat);
                                                      },
                                                    )
                                                  : IconButton(
                                                      icon: Icon(
                                                        Icons.play_arrow,
                                                      ),
                                                      tooltip:
                                                          'resume_audio'.tr,
                                                      onPressed: () {
                                                        c.resumeAudio(ayat);
                                                      },
                                                    ),
                                              IconButton(
                                                icon: Icon(Icons.stop),
                                                tooltip: 'stop_audio'.tr,
                                                onPressed: () {
                                                  c.stopAudio(ayat);
                                                },
                                              ),
                                            ],
                                          ),
                                  ],
                                );
                              })
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${ayat.text?.arab}',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${ayat.text?.transliteration?.en}',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        '${languageController.currentLanguage.value == 'id_ID' ? ayat.translation?.id : ayat.translation?.en}',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
