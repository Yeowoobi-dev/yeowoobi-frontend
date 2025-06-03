// lib/book_log/models/log.dart

import 'dart:convert';

class LogData {
  final int id;
  //final String userId;
  final String title;
  final List<dynamic> content;
  final String background;
  final String visibility;
  final String? review;
  final List<String>? category;
  final String bookTitle;
  final String bookImage;
  final String author;
  final String? publisher;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  LogData({
    required this.id,
    //required this.userId,
    required this.title,
    required this.content,
    required this.background,
    required this.visibility,
    this.review,
    this.category,
    required this.bookTitle,
    required this.bookImage,
    required this.author,
    this.publisher,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory LogData.fromJson(Map<String, dynamic> json) {
    List<dynamic> parsedcontent = [];
    if (json['text'] != null) {
      // String타입이라면 jsonDecode를 사용하여 파싱
      if (json['text'] is String) {
        try {
          parsedcontent = jsonDecode(json['text']);
        } catch (e) {
          print("Failed to parse text JSON: ${json['text']}");
          parsedcontent = [];
        }
        // List타입이라면 그대로 사용
      } else if (json['text'] is List) {
        parsedcontent = json['text'];
      }
    }
    return LogData(
      id: json['id'],
      //userId: json['userId'] ?? '',
      title: json['logTitle'] ?? '',
      content: parsedcontent,
      background: json['background'] ?? '',
      visibility: json['visibility'] ?? '',
      review: json['review'],
      category:
          json['category'] is List ? List<String>.from(json['category']) : null,
      bookTitle: json['bookTitle'] ?? '',
      bookImage: json['bookImage'] ?? '',
      author: json['author'] ?? '',
      publisher: json['publisher'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      version: json['version'] ?? 0,
    );
  }
}
