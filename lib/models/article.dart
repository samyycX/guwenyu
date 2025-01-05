// To parse this JSON data, do
//
//     final article = articleFromJson(jsonString);

import 'dart:convert';

Article articleFromJson(String str) => Article.fromJson(json.decode(str));

String articleToJson(Article data) => json.encode(data.toJson());

class Article {
  String content;
  String title;
  String author;
  List<Reference> references;
  String translation;
  String purport;

  Article({
    required this.content,
    required this.title,
    required this.author,
    required this.references,
    required this.translation,
    required this.purport,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        content: json["content"],
        title: json["title"],
        author: json["author"],
        references: List<Reference>.from(
            json["references"].map((x) => Reference.fromJson(x))),
        translation: json["translation"],
        purport: json["purport"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "title": title,
        "author": author,
        "references": List<dynamic>.from(references.map((x) => x.toJson())),
        "translation": translation,
        "purport": purport,
      };
}

class Reference {
  String allusion;
  String explanation;

  Reference({
    required this.allusion,
    required this.explanation,
  });

  factory Reference.fromJson(Map<String, dynamic> json) => Reference(
        allusion: json["allusion"],
        explanation: json["explanation"],
      );

  Map<String, dynamic> toJson() => {
        "allusion": allusion,
        "explanation": explanation,
      };
}
