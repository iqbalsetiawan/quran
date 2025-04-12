import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/constants/color.dart';

import '../modules/home/controllers/home_controller.dart';

abstract class BaseView extends GetView<HomeController> {
  const BaseView({super.key});

  String get appBarTitle => 'Aplikasi Quran & Hadith';

  Widget get body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.toggleDarkMode(),
            icon: Icon(
              controller.isDarkMode.isTrue
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
              color: appWhite,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: body,
      ),
    );
  }
}
