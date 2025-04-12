import 'package:get/get.dart';
import 'package:quran/app/modules/hadis/controllers/hadis_controller.dart';
import 'package:quran/app/modules/home/controllers/home_controller.dart';
import 'package:quran/app/modules/quran/controllers/quran_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<QuranController>(
      () => QuranController(),
    );
    Get.lazyPut<HadisController>(
      () => HadisController(),
    );
  }
}
