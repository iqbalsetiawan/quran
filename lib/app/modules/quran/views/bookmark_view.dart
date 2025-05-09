import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/routes/app_pages.dart';
import 'package:quran/app/modules/home/controllers/home_controller.dart';
import 'package:quran/app/modules/quran/controllers/quran_controller.dart';

class BookmarkTabView extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  BookmarkTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranController>(
      builder: (c) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: c.getAllBookmark(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Terjadi Kesalahan. Silakan Coba Lagi.',
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak Ada Data'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> bookmark = snapshot.data![index];
                return ListTile(
                  onTap: () {
                    Get.toNamed(
                      Routes.DETAIL_SURAH,
                      arguments: {
                        "name": bookmark['surah'].toString(),
                        "number": bookmark['number_surah'],
                        "bookmark": bookmark,
                      },
                    );
                  },
                  leading: Obx(() {
                    return Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            controller.isDarkMode.isTrue
                                ? 'assets/images/octagonal_dark.png'
                                : 'assets/images/octagonal_light.png',
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                        ),
                      ),
                    );
                  }),
                  title: Text(bookmark['surah']),
                  subtitle: Text(
                    'Ayat: ${bookmark['ayat']} | Via ${bookmark['via']}',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      c.deleteBookmark(
                        bookmark['id'],
                        false,
                      );
                    },
                    icon: const Icon(Icons.delete),
                    tooltip: 'Hapus Markah',
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
