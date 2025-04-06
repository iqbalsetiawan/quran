import 'dart:convert';

import 'package:get/get.dart';
import 'package:quran/app/data/models/surah_detail.dart';
import 'package:http/http.dart' as http;

class DetailSurahController extends GetxController {
  Future<SurahDetail> getDetailSurah(String id) async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah/$id');
    var response = await http.get(url);
    Map<String, dynamic> data =
        (json.decode(response.body) as Map<String, dynamic>)['data'];
    return SurahDetail.fromJson(data);
  }
}
