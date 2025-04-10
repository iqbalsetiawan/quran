import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/app/constants/color.dart';
import 'package:quran/app/data/db/bookmark.dart';
import 'package:quran/app/data/models/juz.dart';
import 'package:quran/app/data/models/surah_main.dart';
import 'package:sqflite/sqlite_api.dart';

class DetailJuzController extends GetxController {
  final player = AudioPlayer();
  DatabaseManager database = DatabaseManager.instance;
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

  Future<void> addBookmark(
      bool lastRead, Surah surah, Verses verse, int indexAyat) async {
    Database db = await database.db;
    bool flagExist = false;

    if (lastRead) {
      await db.delete('bookmark', where: 'last_read = 1');
    } else {
      List duplicate = await db.query('bookmark',
          where:
              "surah = ? and number_surah = ? and ayat = ? and juz = ? and via = ? and index_ayat = ? and last_read = 0",
          whereArgs: [
            surah.name?.transliteration?.id,
            surah.number,
            verse.number?.inSurah,
            verse.meta?.juz,
            'Juz',
            indexAyat
          ]);
      if (duplicate.isNotEmpty) {
        flagExist = true;
      }
    }

    if (!flagExist) {
      await db.insert('bookmark', {
        'surah': surah.name?.transliteration?.id,
        'number_surah': surah.number,
        'ayat': verse.number?.inSurah,
        'juz': verse.meta?.juz,
        'via': 'Juz',
        'index_ayat': indexAyat,
        'last_read': lastRead ? 1 : 0,
      });
      Get.back();
      Get.snackbar(
        'Berhasil',
        lastRead ? 'Terakhir dibaca ditambahkan' : 'Markah ditambahkan',
        colorText: appWhite,
      );
    } else {
      Get.back();
      Get.snackbar(
        'Error',
        'Markah sudah ada',
        colorText: appWhite,
      );
    }
  }
}
