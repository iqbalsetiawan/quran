import 'package:get/get.dart';
import 'package:quran/app/modules/home/views/home_view.dart';

import '../modules/detail_juz/bindings/detail_juz_binding.dart';
import '../modules/detail_juz/views/detail_juz_view.dart';
import '../modules/detail_surah/bindings/detail_surah_binding.dart';
import '../modules/detail_surah/views/detail_surah_view.dart';
import '../modules/hadis/bindings/hadis_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/hadis/views/hadis_view.dart';
import '../modules/introduction/bindings/introduction_binding.dart';
import '../modules/introduction/views/introduction_view.dart';
import '../modules/quran/bindings/quran_binding.dart';
import '../modules/quran/quran.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.INTRODUCTION,
      page: () => IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_SURAH,
      page: () => DetailSurahView(),
      binding: DetailSurahBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_JUZ,
      page: () => DetailJuzView(),
      binding: DetailJuzBinding(),
    ),
    GetPage(
      name: _Paths.QURAN,
      page: () => const Quran(),
      binding: QuranBinding(),
    ),
    GetPage(
      name: _Paths.HADIS,
      page: () => const HadisView(),
      binding: HadisBinding(),
    ),
  ];
}
