import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran/app/constants/color.dart';
import 'package:quran/app/data/models/detail_surah.dart' as detail;
import 'package:quran/app/modules/detail_surah/controllers/detail_surah_controller.dart';
import 'package:quran/app/modules/quran/controllers/quran_controller.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

// ignore: must_be_immutable
class DetailSurahView extends GetView<DetailSurahController> {
  final quranController = Get.find<QuranController>();
  Map<String, dynamic>? bookmark;
  Widget? bismillahWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${Get.arguments['name'].toString().toUpperCase()}'),
        centerTitle: true,
      ),
      body: FutureBuilder<detail.DetailSurah>(
        future: controller.getDetailSurah(Get.arguments['number'].toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Tidak Ada Data'));
          }

          if (Get.arguments['bookmark'] != null) {
            bookmark = Get.arguments['bookmark'];
            controller.scrollController.scrollToIndex(
              bookmark!['index_ayat'] + 3,
              preferPosition: AutoScrollPosition.begin,
            );
          }

          detail.DetailSurah surah = snapshot.data!;
          if (surah.preBismillah != null &&
              snapshot.data!.verses!
                  .any((verse) => verse.number!.inSurah == 1)) {
            bismillahWidget = AutoScrollTag(
              key: ValueKey(2),
              index: 2,
              controller: controller.scrollController,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${surah.preBismillah!.text?.arab}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          List<Widget> allAyat = List.generate(
            snapshot.data!.verses!.length,
            (index) {
              detail.Verse? ayat = snapshot.data!.verses![index];
              return AutoScrollTag(
                key: ValueKey(index + 3),
                index: index + 3,
                controller: controller.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
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
                                child: Text(
                                  '${index + 1}',
                                ),
                              ),
                            ),
                            GetBuilder<DetailSurahController>(builder: (c) {
                              return Row(
                                children: [
                                  IconButton(
                                    icon: Icon(ayat.bookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_border),
                                    tooltip: 'Tambah Markah',
                                    onPressed: () async {
                                      await c.addBookmark(
                                        false,
                                        snapshot.data!,
                                        ayat,
                                        index,
                                      );
                                      quranController.update();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.access_time),
                                    tooltip: 'Tandai sebagai Terakhir Dibaca',
                                    onPressed: () async {
                                      await c.addBookmark(
                                        true,
                                        snapshot.data!,
                                        ayat,
                                        index,
                                      );
                                      quranController.update();
                                    },
                                  ),
                                  (ayat.audioStatus == 'stop')
                                      ? IconButton(
                                          icon: Icon(Icons.play_arrow),
                                          tooltip: 'Putar Bacaan',
                                          onPressed: () {
                                            c.playAudio(ayat);
                                          },
                                        )
                                      : Row(
                                          children: [
                                            (ayat.audioStatus == 'play')
                                                ? IconButton(
                                                    icon: Icon(Icons.pause),
                                                    tooltip: 'Jeda Bacaan',
                                                    onPressed: () {
                                                      c.pauseAudio(ayat);
                                                    },
                                                  )
                                                : IconButton(
                                                    icon: Icon(
                                                      Icons.play_arrow,
                                                    ),
                                                    tooltip: 'Lanjutkan Bacaan',
                                                    onPressed: () {
                                                      c.resumeAudio(ayat);
                                                    },
                                                  ),
                                            IconButton(
                                              icon: Icon(Icons.stop),
                                              tooltip: 'Hentikan Bacaan',
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
                                Divider(
                                  color: appWhite,
                                ),
                                Text(
                                  ' ${surah.revelation?.id} | ${surah.numberOfVerses} Ayat',
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
              AutoScrollTag(
                key: ValueKey(1),
                index: 1,
                controller: controller.scrollController,
                child: SizedBox(height: 20),
              ),
              if (bismillahWidget != null) bismillahWidget!,
              ...allAyat,
            ],
          );
        },
      ),
    );
  }
}
