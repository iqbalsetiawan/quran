import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran/app/constants/color.dart';
import 'package:quran/app/data/models/surah_main.dart';
import 'package:quran/app/data/models/surah_detail.dart' as detail;
import 'package:quran/app/modules/detail_surah/controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  final Surah surah = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${surah.name?.transliteration?.id}'),
        centerTitle: true,
      ),
      body: ListView(
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
          FutureBuilder<detail.SurahDetail>(
            future: controller.getDetailSurah(surah.number.toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No data available'));
              }
              return ListView.builder(
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
                                      onPressed: () {},
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
              );
            },
          ),
        ],
      ),
    );
  }
}
