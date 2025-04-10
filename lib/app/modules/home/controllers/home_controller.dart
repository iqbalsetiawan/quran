import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:quran/app/constants/color.dart';
import 'package:quran/app/data/db/bookmark.dart';
import 'package:quran/app/data/models/juz.dart';
import 'package:quran/app/data/models/surah_main.dart';
import 'package:sqflite/sqlite_api.dart';

class HomeController extends GetxController {
  RxList<Surah> allSurah = <Surah>[].obs;
  RxBool isDarkMode = false.obs;
  final box = GetStorage();
  DatabaseManager database = DatabaseManager.instance;

  Future<List<Surah>> getAllSurah() async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah');
    var response = await http.get(url);
    List? data = (json.decode(response.body) as Map<String, dynamic>)['data'];
    if (data == null || data.isEmpty) {
      return [];
    } else {
      allSurah.value = data.map((e) => Surah.fromJson(e)).toList();
      return allSurah;
    }
  }

  Future<List<Juz>> getAllJuz() async {
    List<Juz> allJuz = [];
    for (int i = 1; i <= 30; i++) {
      Uri url = Uri.parse('https://api.quran.gading.dev/juz/$i');
      var response = await http.get(url);
      Map<String, dynamic>? data =
          (json.decode(response.body) as Map<String, dynamic>)['data'];
      if (data == null || data.isEmpty) {
        return [];
      } else {
        allJuz.add(Juz.fromJson(data));
      }
    }
    return allJuz;
  }

  Future<List<Map<String, dynamic>>> getAllBookmark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allBookmark = await db.query(
      'bookmark',
      where: "last_read = 0",
      orderBy: "number_surah, ayat",
    );
    return allBookmark;
  }

  void deleteBookmark(int id, bool isLastRead) async {
    Database db = await database.db;
    await db.delete('bookmark', where: 'id = ?', whereArgs: [id]);
    update();
    Get.back();
    Snackbar.showSnackbar(
      'Success',
      isLastRead
          ? 'Terakhir dibaca berhasil dihapus'
          : 'Markah berhasil dihapus',
    );
  }

  Future<Map<String, dynamic>?> getLastRead() async {
    Database db = await database.db;
    List<Map<String, dynamic>> lastRead =
        await db.query('bookmark', where: "last_read = 1");
    if (lastRead.isEmpty) {
      return null;
    }
    return lastRead.first;
  }

  void toggleDarkMode() {
    Get.changeTheme(Get.isDarkMode ? themeLight : themeDark);
    isDarkMode.toggle();
    if (Get.isDarkMode) {
      box.remove('themeDark');
    } else {
      box.write('themeDark', true);
    }
  }
}
