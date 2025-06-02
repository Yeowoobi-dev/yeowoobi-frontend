// lib/book_log/models/log.dart

import 'dart:convert';

class LogData {
  final int id;
  //final String userId;
  final String title;
  final List<dynamic> text;
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
    required this.text,
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
    List<dynamic> parsedText = [];
    if (json['text'] != null) {
      if (json['text'] is String) {
        try {
          parsedText = jsonDecode(json['text']);
        } catch (e) {
          print("Failed to parse text JSON: ${json['text']}");
          parsedText = [];
        }
      } else if (json['text'] is List) {
        parsedText = json['text'];
      }
    }
    return LogData(
      id: json['id'],
      //userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      text: parsedText,
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
