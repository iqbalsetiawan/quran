import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/home/controllers/home_controller.dart';

abstract class BaseView extends GetView<HomeController> {
  const BaseView({super.key});

  String get appBarTitle;

  Widget get body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: body,
      ),
    );
  }
}
