import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/routes/app_pages.dart';

import 'package:quran/app/constants/color.dart';
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
              Container(
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
                    onTap: () {},
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
                                SizedBox(height: 20),
                                Text(
                                  'Al-Fatihah',
                                  style: TextStyle(
                                    color: appWhite,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Verses: 7',
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
              ),
              TabBar(
                tabs: [
                  Tab(text: 'Surah'),
                  Tab(text: 'Juz'),
                  Tab(text: 'Tafsir'),
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
                              child: Text('Error: ${snapshot.error}'));
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
                                Get.toNamed(Routes.DETAIL_SURAH,
                                    arguments: surah);
                              },
                            );
                          },
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            'Juz ${index + 1}',
                          ),
                          leading: Obx(
                            () {
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
                                    style: TextStyle(
                                      color: controller.isDarkMode.isTrue
                                          ? appWhite
                                          : appPurpleDark,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          onTap: () {},
                        );
                      },
                    ),
                    Center(child: Text('Tafsir')),
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
