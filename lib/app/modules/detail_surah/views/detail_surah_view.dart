import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran/app/constants/color.dart';
import 'package:quran/app/data/models/surah_detail.dart' as detail;
import 'package:quran/app/modules/detail_surah/controllers/detail_surah_controller.dart';
import 'package:quran/app/modules/home/controllers/home_controller.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

// ignore: must_be_immutable
class DetailSurahView extends GetView<DetailSurahController> {
  final homeController = Get.find<HomeController>();
  Map<String, dynamic>? bookmark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${Get.arguments['name'].toString().toUpperCase()}'),
        centerTitle: true,
      ),
      body: FutureBuilder<detail.SurahDetail>(
        future: controller.getDetailSurah(Get.arguments['number'].toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Tidak ada data'));
          }

          if (Get.arguments['bookmark'] != null) {
            bookmark = Get.arguments['bookmark'];
            controller.scrollController.scrollToIndex(
              bookmark!['index_ayat'] + 2,
              preferPosition: AutoScrollPosition.begin,
            );
          }

          detail.SurahDetail surah = snapshot.data!;

          List<Widget> allAyat = List.generate(
            snapshot.data!.verses!.length,
            (index) {
              detail.Verse? ayat = snapshot.data!.verses![index];
              return AutoScrollTag(
                key: ValueKey(index + 2),
                index: index + 2,
                controller: controller.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: appPurpleLight2.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
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
                                child: Text(
                                  '${index + 1}',
                                ),
                              ),
                            ),
                            GetBuilder<DetailSurahController>(builder: (c) {
                              return Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.bookmark_add_outlined),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: 'Markah',
                                        middleText: 'Pilih Tipe Markah',
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              await c.addBookmark(
                                                true,
                                                snapshot.data!,
                                                ayat,
                                                index,
                                              );
                                              homeController.update();
                                            },
                                            child: Text('Terakhir Dibaca'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: appPurple,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              c.addBookmark(
                                                false,
                                                snapshot.data!,
                                                ayat,
                                                index,
                                              );
                                            },
                                            child: Text('Markah'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: appPurple,
                                            ),
                                          ),
                                        ],
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
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
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
              );
            },
          );

          return ListView(
            controller: controller.scrollController,
            padding: EdgeInsets.all(20),
            children: [
              AutoScrollTag(
                key: ValueKey(0),
                index: 0,
                controller: controller.scrollController,
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
                                '${surah.tafsir?.id}',
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
                        colors: [
                          appPurpleLight1,
                          appPurpleDark,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            '${surah.name?.transliteration?.id?.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: appWhite,
                            ),
                          ),
                          Text(
                            '(${surah.name?.translation?.id?.toUpperCase()})',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: appWhite,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${surah.numberOfVerses} Ayat | ${surah.revelation?.id}',
                            style: TextStyle(
                              fontSize: 16,
                              color: appWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AutoScrollTag(
                key: ValueKey(1),
                index: 1,
                controller: controller.scrollController,
                child: SizedBox(height: 20),
              ),
              ...allAyat,
            ],
          );
        },
      ),
    );
  }
}
