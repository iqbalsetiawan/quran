// API URL: https://api.hadith.gading.dev/books/muslim?range=1-150
//
// To parse this JSON data, do
//
//     final bookDetail = bookDetailFromJson(jsonString);

import 'dart:convert';

BookDetail bookDetailFromJson(String str) => BookDetail.fromJson(json.decode(str));

String bookDetailToJson(BookDetail data) => json.encode(data.toJson());

class BookDetail {
    String? name;
    String? id;
    int? available;
    int? requested;
    List<Hadith>? hadiths;

    BookDetail({
        this.name,
        this.id,
        this.available,
        this.requested,
        this.hadiths,
    });

    factory BookDetail.fromJson(Map<String, dynamic> json) => BookDetail(
        name: json["name"],
        id: json["id"],
        available: json["available"],
        requested: json["requested"],
        hadiths: List<Hadith>.from(json["hadiths"].map((x) => Hadith.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "available": available,
        "requested": requested,
        "hadiths": List<dynamic>.from(hadiths!.map((x) => x.toJson())),
    };
}

class Hadith {
    int? number;
    String? arab;
    String? id;

    Hadith({
        this.number,
        this.arab,
        this.id,
    });

    factory Hadith.fromJson(Map<String, dynamic> json) => Hadith(
        number: json["number"],
        arab: json["arab"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "number": number,
        "arab": arab,
        "id": id,
    };
}
