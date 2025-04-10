import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/app/components/snackbar.dart';
import 'package:quran/app/data/db/bookmark.dart';
import 'package:quran/app/data/models/juz.dart';
import 'package:quran/app/data/models/surah.dart';
import 'package:sqflite/sqlite_api.dart';

class DetailJuzController extends GetxController {
  AudioPlayer player = AudioPlayer();
  DatabaseManager database = DatabaseManager.instance;
  Verses? lastVerse;

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    _setupPlayerListener();
    super.onInit();
  }

  void _setupPlayerListener() {
    player.playbackEventStream.listen((event) {}, onError: _handleError);
  }

  Future<void> playAudio(Verses verse) async {
    try {
      lastVerse?.audioStatus = 'stop';
      lastVerse = verse;
      update();
      await player.stop();
      await player.setUrl(verse.audio?.primary ??
          verse.audio?.secondary?[0] ??
          verse.audio?.secondary?[1] ??
          '');
      verse.audioStatus = 'play';
      update();
      await player.play();
      verse.audioStatus = 'stop';
      await player.stop();
      update();
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> pauseAudio(Verses verse) async {
    try {
      await player.pause();
      verse.audioStatus = 'pause';
      update();
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> resumeAudio(Verses verse) async {
    try {
      verse.audioStatus = 'play';
      update();
      await player.play();
      verse.audioStatus = 'stop';
      update();
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> stopAudio(Verses verse) async {
    try {
      await player.stop();
      verse.audioStatus = 'stop';
      update();
    } catch (e) {
      _handleError(e);
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
      Snackbar.showSnackbar(
        'Berhasil',
        lastRead ? 'Terakhir dibaca ditambahkan' : 'Markah ditambahkan',
      );
    } else {
      Get.back();
      Snackbar.showSnackbar(
        'Error',
        'Markah sudah ada',
      );
    }
  }

  void _handleError(Object e, [StackTrace? st]) {
    String title = 'Error';
    String message;

    switch (e.runtimeType) {
      case PlayerException:
        final error = e as PlayerException;
        print("Error code: ${error.code}");
        print("Error message: ${error.message}");
        message = error.message ?? 'Audio playback failed';
        break;
      case PlayerInterruptedException:
        final error = e as PlayerInterruptedException;
        print("Connection aborted: ${error.message}");
        message = 'Connection aborted: ${error.message}';
        break;
      case PlatformException:
        final error = e as PlatformException;
        print('Error code: ${error.code}');
        print('Error message: ${error.message}');
        print('AudioSource index: ${error.details?["index"]}');
        message = error.message ?? 'Platform error occurred';
        break;
      default:
        print('An error occurred: $e');
        message = 'An error occurred: $e';
    }
    Snackbar.showSnackbar(title, message);
  }
}
