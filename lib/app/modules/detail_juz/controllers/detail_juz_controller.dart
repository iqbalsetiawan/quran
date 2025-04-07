import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/app/data/models/juz.dart';

class DetailJuzController extends GetxController {
  final player = AudioPlayer();
  Verses? lastVerse;

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }

  void playAudio(Verses verse) async {
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

  void pauseAudio(Verses verse) async {
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

  void resumeAudio(Verses verse) async {
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

  void stopAudio(Verses verse) async {
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
