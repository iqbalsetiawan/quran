import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quran/app/data/models/book_detail.dart';

class DetailBookController extends GetxController {
  Future<BookDetail> getDetailBook(String id) async {
    Uri url = Uri.parse('https://api.quran.gading.dev/books/$id?range=1-150');
    var response = await http.get(url);
    Map<String, dynamic> data = (json.decode(response.body) as Map<String, dynamic>)['data'];
    return BookDetail.fromJson(data);
  }
}
