import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/app/data/models/surah_detail.dart';
import 'package:http/http.dart' as http;

class DetailSurahController extends GetxController {
  final player = AudioPlayer();

  Verse? lastVerse;

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }

  Future<SurahDetail> getDetailSurah(String id) async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah/$id');
    var response = await http.get(url);
    Map<String, dynamic> data =
        (json.decode(response.body) as Map<String, dynamic>)['data'];
    return SurahDetail.fromJson(data);
  }

  void playAudio(Verse verse) async {
    if (verse.audio?.primary != null) {
      try {
        if (lastVerse == null) {
          lastVerse = verse;
        }
        lastVerse?.audioStatus = 'stop';
        lastVerse = verse;
        lastVerse?.audioStatus = 'stop';
        update();
        await player.stop();
        await player.setUrl(verse.audio?.primary ?? '');
        verse.audioStatus = 'play';
        update();
        await player.play();
        verse.audioStatus = 'stop';
        await player.stop();
        update();
      } on PlayerException catch (e) {
        print("Error code: ${e.code}");
        print("Error message: ${e.message}");
        Get.snackbar('Error', '${e.message}');
      } on PlayerInterruptedException catch (e) {
        print("Connection aborted: ${e.message}");
        Get.snackbar('Error', 'Connection aborted: ${e.message}');
      } catch (e) {
        print('An error occured: $e');
        Get.snackbar('Error', 'An error occured: $e');
      }

      player.playbackEventStream.listen((event) {},
          onError: (Object e, StackTrace st) {
        if (e is PlatformException) {
          print('Error code: ${e.code}');
          print('Error message: ${e.message}');
          print('AudioSource index: ${e.details?["index"]}');
        } else {
          print('An error occurred: $e');
        }
      });
    } else {
      Get.snackbar('Error', 'Audio not found');
    }
  }

  void pauseAudio(Verse verse) async {
    try {
      await player.pause();
      verse.audioStatus = 'pause';
      update();
    } on PlayerException catch (e) {
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
      Get.snackbar('Error', '${e.message}');
    } on PlayerInterruptedException catch (e) {
      print("Connection aborted: ${e.message}");
      Get.snackbar('Error', 'Connection aborted: ${e.message}');
    } catch (e) {
      print('An error occured: $e');
      Get.snackbar('Error', 'An error occured: $e');
    }

    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace st) {
      if (e is PlatformException) {
        print('Error code: ${e.code}');
        print('Error message: ${e.message}');
        print('AudioSource index: ${e.details?["index"]}');
      } else {
        print('An error occurred: $e');
      }
    });
  }

  void resumeAudio(Verse verse) async {
    try {
      verse.audioStatus = 'play';
      update();
      await player.play();
      verse.audioStatus = 'stop';
      update();
    } on PlayerException catch (e) {
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
      Get.snackbar('Error', '${e.message}');
    } on PlayerInterruptedException catch (e) {
      print("Connection aborted: ${e.message}");
      Get.snackbar('Error', 'Connection aborted: ${e.message}');
    } catch (e) {
      print('An error occured: $e');
      Get.snackbar('Error', 'An error occured: $e');
    }
  }

  void stopAudio(Verse verse) async {
    try {
      await player.stop();
      verse.audioStatus = 'stop';
      update();
    } on PlayerException catch (e) {
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
      Get.snackbar('Error', '${e.message}');
    } on PlayerInterruptedException catch (e) {
      print("Connection aborted: ${e.message}");
      Get.snackbar('Error', 'Connection aborted: ${e.message}');
    } catch (e) {
      print('An error occured: $e');
      Get.snackbar('Error', 'An error occured: $e');
    }
  }
}
