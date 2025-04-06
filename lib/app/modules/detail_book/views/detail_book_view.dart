import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hadith/app/data/models/book_detail.dart';
import 'package:hadith/app/data/models/book_main.dart';

import '../controllers/detail_book_controller.dart';

class DetailBookView extends GetView<DetailBookController> {
  final Book book = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hadith by ${book.name}'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    '${book.name}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<BookDetail>(
            future: controller.getDetailBook(book.id.toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No data available'));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 150,
                itemBuilder: (context, index) {
                  BookDetail detail = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              IconButton(
                                icon: Icon(Icons.bookmark_add_outlined),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${detail.hadiths![index].arab}',
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.end,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${detail.hadiths![index].id}',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 50),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
