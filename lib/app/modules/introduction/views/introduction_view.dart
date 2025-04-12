import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quran/app/constants/color.dart';
import 'package:quran/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aplikasi Quran & Hadith',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                'Selamat Datang di Aplikasi Quran & Hadith',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Lottie.asset(
              'assets/lotties/opener.json',
              width: 300,
              height: 300,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.offAllNamed(Routes.HOME);
              },
              child: Text(
                'Mulai',
                style: TextStyle(
                  color: Get.isDarkMode ? appPurpleDark : appWhite,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.isDarkMode ? appWhite : appPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
