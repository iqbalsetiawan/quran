import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:quran/app/components/snackbar.dart';

import 'package:quran/app/data/db/bookmark.dart';
import 'package:quran/app/data/models/juz.dart';
import 'package:quran/app/data/models/surah.dart';
import 'package:sqflite/sqlite_api.dart';

class QuranController extends GetxController {
  RxList<Surah> allSurah = <Surah>[].obs;
  final box = GetStorage();
  DatabaseManager database = DatabaseManager.instance;

  Future<List<Surah>> getAllSurah() async {
    if (box.read('allSurah') != null) {
      List<dynamic> savedData = box.read('allSurah');
      allSurah.value = savedData.map((e) => Surah.fromJson(e)).toList();
      return allSurah;
    } else {
      Uri url = Uri.parse('https://api.quran.gading.dev/surah');
      var response = await http.get(url);
      List? data = (json.decode(response.body) as Map<String, dynamic>)['data'];

      if (data == null || data.isEmpty) {
        return [];
      } else {
        allSurah.value = data.map((e) => Surah.fromJson(e)).toList();
        box.write('allSurah', data);
        return allSurah;
      }
    }
  }

  Future<List<Juz>> getAllJuz() async {
    if (box.read('allJuz') != null) {
      List<dynamic> savedData = box.read('allJuz');
      return savedData.map((e) => Juz.fromJson(e)).toList();
    } else {
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
      box.write('allJuz', allJuz.map((e) => e.toJson()).toList());
      return allJuz;
    }
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
      'success'.tr,
      isLastRead
          ? 'last_read_deleted'.tr
          : 'bookmark_deleted'.tr,
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
}
