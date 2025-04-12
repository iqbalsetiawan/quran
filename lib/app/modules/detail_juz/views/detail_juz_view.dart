import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/constants/color.dart';

import 'package:quran/app/data/models/juz.dart' as juz;
import 'package:quran/app/data/models/surah.dart';
import 'package:quran/app/modules/detail_juz/controllers/detail_juz_controller.dart';
import 'package:quran/app/modules/quran/controllers/quran_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  final juz.Juz detailJuz = Get.arguments[0];
  final List<Surah> allSurahInJuz = Get.arguments[1];
  final homeController = Get.find<QuranController>();

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
                return Center(child: Text('Tidak ada data'));
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
                                      '(${allSurahInJuz[surahIndex].name?.translation?.id?.toUpperCase()})',
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
                                      '${allSurahInJuz[surahIndex].revelation?.id} | ${allSurahInJuz[surahIndex].numberOfVerses} Ayat',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (ayat.number?.inSurah == 1 &&
                          ayat.number?.inQuran != 1 &&
                          ayat.number?.inQuran != 1236) ...[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                                    height: 40,
                                    width: 40,
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
                                      onPressed: () {
                                        Get.defaultDialog(
                                          titlePadding: EdgeInsets.only(
                                              top: 20, bottom: 10),
                                          title: 'Segera Hadir',
                                          middleText:
                                              'Fitur ini akan segera hadir!',
                                        );
                                      },
                                    ),
                                    (ayat.audioStatus == 'stop')
                                        ? IconButton(
                                            icon: Icon(Icons.play_arrow),
                                            onPressed: () {
                                              c.playAudio(ayat);
                                            },
                                          )
                                        : Row(
                                            children: [
                                              (ayat.audioStatus == 'play')
                                                  ? IconButton(
                                                      icon: Icon(Icons.pause),
                                                      onPressed: () {
                                                        c.pauseAudio(ayat);
                                                      },
                                                    )
                                                  : IconButton(
                                                      icon: Icon(
                                                        Icons.play_arrow,
                                                      ),
                                                      onPressed: () {
                                                        c.resumeAudio(ayat);
                                                      },
                                                    ),
                                              IconButton(
                                                icon: Icon(Icons.stop),
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
                        '${ayat.translation?.id}',
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
