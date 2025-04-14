import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/routes/app_pages.dart';
import 'package:quran/app/data/models/surah.dart';
import 'package:quran/app/data/models/juz.dart' as juz;
import 'package:quran/app/modules/home/controllers/home_controller.dart';
import 'package:quran/app/modules/quran/controllers/quran_controller.dart';

class JuzTabView extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  JuzTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranController>(
      builder: (c) {
        return FutureBuilder<List<juz.Juz>>(
          future: c.getAllJuz(),
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
                juz.Juz detailJuz = snapshot.data![index];

                String nameStart = detailJuz.juzStartInfo!.split(' - ')[0];
                String nameEnd = detailJuz.juzEndInfo!.split(' - ')[0];

                List<Surah> rawAllSurahInJuz = [];
                List<Surah> allSurahInJuz = [];

                for (Surah item in c.allSurah) {
                  rawAllSurahInJuz.add(item);
                  if (item.name!.transliteration!.id == nameEnd) {
                    break;
                  }
                }

                for (Surah item in rawAllSurahInJuz.reversed.toList()) {
                  allSurahInJuz.add(item);
                  if (item.name!.transliteration!.id == nameStart) {
                    break;
                  }
                }

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  onTap: () {
                    Get.toNamed(
                      Routes.DETAIL_JUZ,
                      arguments: [
                        detailJuz,
                        allSurahInJuz.reversed.toList(),
                      ],
                    );
                  },
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
                          '${index + 1}',
                        ),
                      ),
                    );
                  }),
                  isThreeLine: true,
                  title: Text(
                    '${'juz'.tr} ${index + 1}',
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'start'.tr}: ${detailJuz.juzStartInfo}',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                      Text(
                        '${'end'.tr}: ${detailJuz.juzEndInfo}',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
