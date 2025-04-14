import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/modules/quran/views/bookmark_view.dart';
import 'package:quran/app/modules/quran/views/juz_view.dart';
import 'package:quran/app/modules/quran/views/surah_view.dart';
import 'package:quran/app/routes/app_pages.dart';
import 'package:quran/app/views/base_view.dart';
import 'package:quran/app/constants/color.dart';
import 'package:quran/app/modules/quran/controllers/quran_controller.dart';

class Quran extends BaseView {
  const Quran({super.key});

  @override
  String get appBarTitle => 'app_title'.tr;

  @override
  Widget get body => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: DefaultTabController(
          length: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assalamu\'alaikum',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GetBuilder<QuranController>(builder: (c) {
                return FutureBuilder<Map<String, dynamic>?>(
                  future: c.getLastRead(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
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
                                      const Icon(Icons.menu_book_rounded,
                                          color: appWhite),
                                      const SizedBox(width: 10),
                                      Text(
                                        'last_read'.tr,
                                        style: TextStyle(
                                          color: appWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    'loading'.tr,
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
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
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
                          onTap: () {
                            if (lastRead != null) {
                              Get.toNamed(
                                Routes.DETAIL_SURAH,
                                arguments: {
                                  "name": lastRead['surah'].toString(),
                                  "number": lastRead['number_surah'],
                                  "bookmark": lastRead,
                                },
                              );
                            }
                          },
                          onLongPress: () {
                            if (lastRead != null) {
                              Get.defaultDialog(
                                title: 'delete_last_read'.tr,
                                middleText: 'confirm_delete_last_read'.tr,
                                actions: [
                                  OutlinedButton(
                                    onPressed: () => Get.back(),
                                    child: Text('cancel'.tr),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => c.deleteBookmark(
                                      lastRead['id'],
                                      true,
                                    ),
                                    child: Text('delete'.tr),
                                  ),
                                ],
                              );
                            }
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
                                          const Icon(Icons.menu_book_rounded,
                                              color: appWhite),
                                          const SizedBox(width: 10),
                                          Text(
                                            'last_read'.tr,
                                            style: TextStyle(
                                              color: appWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 30),
                                      Text(
                                        lastRead == null
                                            ? 'no_last_read'.tr
                                            : "${lastRead['surah']}",
                                        style: TextStyle(
                                          color: appWhite,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        lastRead == null
                                            ? ''
                                            : '${'juz'.tr}: ${lastRead['juz']} | ${'ayat'.tr}: ${lastRead['ayat']}',
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
                  Tab(text: 'surah'.tr),
                  Tab(text: 'juz'.tr),
                  Tab(text: 'bookmark'.tr),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TabBarView(
                    children: [
                      SurahTabView(),
                      JuzTabView(),
                      BookmarkTabView(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
