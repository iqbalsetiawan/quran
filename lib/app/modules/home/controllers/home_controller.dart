import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:quran/app/constants/color.dart';
import 'package:quran/app/data/models/juz.dart';
import 'package:quran/app/data/models/surah_main.dart';

class HomeController extends GetxController {
  RxBool isDarkMode = false.obs;

  Future<List<Surah>> getAllSurah() async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah');
    var response = await http.get(url);
    List? data = (json.decode(response.body) as Map<String, dynamic>)['data'];
    if (data == null || data.isEmpty) {
      return [];
    } else {
      return data.map((e) => Surah.fromJson(e)).toList();
    }
  }

  Future<List<Juz>> getAllJuz() async {
    List<Juz> allJuz = [];
    for (int i = 1; i <= 30; i++) {
      Uri url = Uri.parse('https://api.quran.gading.dev/juz/$i');
      var response = await http.get(url);
      Map<String, dynamic>? data = (json.decode(response.body) as Map<String, dynamic>)['data'];
      if (data == null || data.isEmpty) {
        return [];
      } else {
        allJuz.add(Juz.fromJson(data));
      }
    }
    return allJuz;
  }

  void toggleDarkMode() {
    Get.changeTheme(Get.isDarkMode ? themeLight : themeDark);
    isDarkMode.toggle();
  }
}
