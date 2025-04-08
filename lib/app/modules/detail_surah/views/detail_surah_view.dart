import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran/app/constants/color.dart';
import 'package:quran/app/data/models/surah_detail.dart' as detail;
import 'package:quran/app/modules/detail_surah/controllers/detail_surah_controller.dart';
import 'package:quran/app/modules/home/controllers/home_controller.dart';

// ignore: must_be_immutable
class DetailSurahView extends GetView<DetailSurahController> {
  final homeController = Get.find<HomeController>();
  Map<String, dynamic>? bookmark;

  @override
  Widget build(BuildContext context) {
    if (Get.arguments['bookmark'] != null) {
      bookmark = Get.arguments['bookmark'];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${Get.arguments['name']}'),
        centerTitle: true,
      ),
      body: FutureBuilder<detail.SurahDetail>(
        future: controller.getDetailSurah(Get.arguments['number'].toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          detail.SurahDetail surah = snapshot.data!;

          return ListView(
            padding: EdgeInsets.all(20),
            children: [
              GestureDetector(
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
                          '${surah.numberOfVerses} Verses | ${surah.revelation?.id}',
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
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.verses!.length,
                itemBuilder: (context, index) {
                  if (snapshot.data!.verses!.length == 0) {
                    return SizedBox();
                  }
                  detail.Verse ayat = snapshot.data!.verses![index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
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
                                          title: 'Bookmark',
                                          middleText: 'Select Bookmark Type',
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
                                              child: Text('Last Read'),
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
                                              child: Text('Bookmark'),
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
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
