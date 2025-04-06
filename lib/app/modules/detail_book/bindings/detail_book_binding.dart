import 'package:get/get.dart';

import '../controllers/detail_book_controller.dart';

class DetailBookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailBookController>(
      () => DetailBookController(),
    );
  }
}
