import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/app/components/snackbar.dart';
import 'package:quran/app/data/db/bookmark.dart';
import 'package:quran/app/data/models/surah_detail.dart';
import 'package:http/http.dart' as http;
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sqflite/sqlite_api.dart';

class DetailSurahController extends GetxController {
  AutoScrollController scrollController = AutoScrollController();
  DatabaseManager database = DatabaseManager.instance;
  Verse? lastVerse;
  final player = AudioPlayer();

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

  Future<SurahDetail> getDetailSurah(String id) async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah/$id');
    var response = await http.get(url);
    Map<String, dynamic> data =
        (json.decode(response.body) as Map<String, dynamic>)['data'];
    return SurahDetail.fromJson(data);
  }

  void playAudio(Verse verse) async {
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

  void pauseAudio(Verse verse) async {
    try {
      await player.pause();
      verse.audioStatus = 'pause';
      update();
    } catch (e) {
      _handleError(e);
    }
  }

  void resumeAudio(Verse verse) async {
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

  void stopAudio(Verse verse) async {
    try {
      await player.stop();
      verse.audioStatus = 'stop';
      update();
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> addBookmark(
      bool lastRead, SurahDetail surah, Verse verse, int indexAyat) async {
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
            'Surah',
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
        'via': 'Surah',
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
