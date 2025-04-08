import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/routes/app_pages.dart';

import 'package:quran/app/constants/color.dart';
import 'package:quran/app/data/models/juz.dart' as juz;
import 'package:quran/app/data/models/surah_main.dart';
import 'package:quran/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDarkMode.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Quran & Hadith App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.SEARCH);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assalamu\'alaikum',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GetBuilder<HomeController>(builder: (c) {
                return FutureBuilder<Map<String, dynamic>?>(
                  future: c.getLastRead(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              appPurpleLight1,
                              appPurpleDark,
                            ],
                          ),
                        ),
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
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.menu_book_rounded,
                                          color: appWhite),
                                      SizedBox(width: 10),
                                      Text(
                                        'Last Read',
                                        style: TextStyle(
                                          color: appWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                  Text(
                                    'Loading...',
                                    style: TextStyle(
                                      color: appWhite,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                      color: appWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    Map<String, dynamic>? lastRead = snapshot.data;
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
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
                        child: InkWell(
                          onLongPress: () {
                            if (lastRead != null) {
                              Get.defaultDialog(
                                title: 'Delete Last Read',
                                middleText:
                                    'Are you sure you want to delete this last read?',
                                actions: [
                                  OutlinedButton(
                                    onPressed: () => Get.back(),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => c.deleteBookmark(
                                      lastRead['id'],
                                      true,
                                    ),
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            }
                          },
                          onTap: () {
                            if (lastRead != null) {}
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
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
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.menu_book_rounded,
                                              color: appWhite),
                                          SizedBox(width: 10),
                                          Text(
                                            'Last Read',
                                            style: TextStyle(
                                              color: appWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                      Text(
                                        lastRead == null
                                            ? 'No last read'
                                            : "${lastRead['surah']}",
                                        style: TextStyle(
                                          color: appWhite,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        lastRead == null
                                            ? ''
                                            : 'Juz: ${lastRead['juz']} | Verses: ${lastRead['ayat']}',
                                        style: TextStyle(
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
                    );
                  },
                );
              }),
              TabBar(
                tabs: [
                  Tab(text: 'Surah'),
                  Tab(text: 'Juz'),
                  Tab(text: 'Bookmark'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FutureBuilder<List<Surah>>(
                      future: controller.getAllSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No data available'));
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Surah surah = snapshot.data![index];
                            return ListTile(
                              title: Text(
                                '${surah.name?.transliteration?.id}',
                              ),
                              subtitle: Text(
                                '${surah.numberOfVerses} Verses | ${surah.revelation?.id}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                              leading: Obx(() {
                                return Container(
                                  width: 35,
                                  height: 35,
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
                    ),
                    FutureBuilder<List<juz.Juz>>(
                      future: controller.getAllJuz(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No data available'));
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            juz.Juz detailJuz = snapshot.data![index];

                            String nameStart =
                                detailJuz.juzStartInfo!.split(' - ')[0];
                            String nameEnd =
                                detailJuz.juzEndInfo!.split(' - ')[0];

                            List<Surah> rawAllSurahInJuz = [];
                            List<Surah> allSurahInJuz = [];

                            for (Surah item in controller.allSurah) {
                              rawAllSurahInJuz.add(item);
                              if (item.name!.transliteration!.id == nameEnd) {
                                break;
                              }
                            }

                            for (Surah item
                                in rawAllSurahInJuz.reversed.toList()) {
                              allSurahInJuz.add(item);
                              if (item.name!.transliteration!.id == nameStart) {
                                break;
                              }
                            }

                            return ListTile(
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
                                  width: 35,
                                  height: 35,
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
                                'Juz ${index + 1}',
                              ),
                              subtitle: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Start: ${detailJuz.juzStartInfo}',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    'End: ${detailJuz.juzEndInfo}',
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
                    ),
                    GetBuilder<HomeController>(
                      builder: (c) {
                        return FutureBuilder<List<Map<String, dynamic>>>(
                          future: c.getAllBookmark(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Error: ${snapshot.error}',
                                ),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(child: Text('No data available'));
                            }
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> bookmark =
                                    snapshot.data![index];
                                return ListTile(
                                  onTap: () {
                                    Get.toNamed(
                                      Routes.DETAIL_SURAH,
                                      arguments: {
                                        "name": bookmark['surah'].toString(),
                                        "number": bookmark['number_surah'],
                                        "bookmark": bookmark,
                                      },
                                    );
                                  },
                                  leading: Obx(() {
                                    return Container(
                                      width: 35,
                                      height: 35,
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
                                  title: Text(bookmark['surah']),
                                  subtitle: Text(
                                    'Verses: ${bookmark['ayat']} - Via ${bookmark['via']}',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      controller.deleteBookmark(
                                        bookmark['id'],
                                        false,
                                      );
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.toggleDarkMode(),
        child: Obx(
          () => Icon(
            Icons.brightness_4,
            color: controller.isDarkMode.isTrue ? appPurpleDark : appWhite,
          ),
        ),
      ),
    );
  }
}
