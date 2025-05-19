import 'dart:convert';
import 'package:flutter/services.dart';

class SnsPost {
  final String bookTitle;
  final String title;
  final String uploader;
  final String time;
  final int likes;
  final int comments;
  final String image;
  final String review;
  final String author;
  final String bookImage;

  SnsPost({
    required this.bookTitle,
    required this.title,
    required this.uploader,
    required this.time,
    required this.likes,
    required this.comments,
    required this.image,
    required this.review,
    required this.author,
    required this.bookImage,
  });

  factory SnsPost.fromJson(Map<String, dynamic> json) {
    return SnsPost(
      bookTitle: json['bookTitle'],
      title: json['title'],
      uploader: json['uploader'],
      time: json['time'],
      likes: json['likes'],
      comments: json['comments'],
      image: json['image'],
      review: json['review'],
      author: json['author'],
      bookImage: json['bookImage'],
    );
  }
}

Future<List<SnsPost>> loadSnsPosts() async {
  final String jsonString = await rootBundle.loadString('lib/sns/sns_dummy.json');
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((json) => SnsPost.fromJson(json)).toList();
}
