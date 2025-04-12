import 'package:get/get.dart';
import 'package:quran/app/constants/color.dart';

class Snackbar {
  // TODO: Play bismillah di setiap surat
  // TODO: Play audio berkelanjutan
  // TODO: Ganti logo dan nama aplikasi
  // TODO: Ganti splash screen
  // TODO: Update ukuran logo ayat di surat dan juz
  // TODO: Handle ketika hp sedang aktif dark mode (solusi menyusul)
  // TODO: Beri loading ketika pergantian mode light / dark
  // TODO: Localization
  static void showSnackbar(String? title, String? message) {
    Get.snackbar(
      title ?? 'Error',
      message ?? 'An error occurred',
      colorText: appWhite,
    );
  }
}
