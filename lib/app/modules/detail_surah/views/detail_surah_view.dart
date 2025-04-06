import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran/app/data/models/surah_main.dart';
import 'package:quran/app/data/models/surah_detail.dart' as detail;
import '../controllers/detail_surah_controller.dart';

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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    '${surah.name?.transliteration?.id?.toUpperCase()}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '(${surah.name?.translation?.id?.toUpperCase()})',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${surah.numberOfVerses} Verses | ${surah.revelation?.id}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
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
                      Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.bookmark_add_outlined),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.play_arrow),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
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
