import 'package:get/get.dart';

import '../controllers/hadis_controller.dart';

class HadisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HadisController>(
      () => HadisController(),
    );
  }
}
