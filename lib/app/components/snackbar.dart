import 'package:get/get.dart';
import 'package:quran/app/constants/color.dart';

class Snackbar {
  static void showSnackbar(String? title, String? message) {
    Get.snackbar(
      title ?? 'Error',
      message ?? 'An error occurred',
      colorText: appWhite,
    );
  }
}
