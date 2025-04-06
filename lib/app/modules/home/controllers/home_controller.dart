import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'package:quran/app/constants/color.dart';
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

  void toggleDarkMode() {
    Get.changeTheme(Get.isDarkMode ? themeLight : themeDark);
    isDarkMode.toggle();
  }
}
