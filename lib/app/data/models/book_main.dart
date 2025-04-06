// API URL: https://api.hadith.gading.dev/books
//
// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

Book bookFromJson(String str) => Book.fromJson(json.decode(str));

String bookToJson(Book data) => json.encode(data.toJson());

class Book {
  String? name;
  String? id;
  int? available;

  Book({
    this.name,
    this.id,
    this.available,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        name: json["name"],
        id: json["id"],
        available: json["available"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "available": available,
      };
}
