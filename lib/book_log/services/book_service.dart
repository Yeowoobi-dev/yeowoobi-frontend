// book_log/services/book_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book.dart';

class MyBookLogService {
  // 내 독서록
  static Future<List<Book>> fetchDummyBooks() async {
    try {
      final String response = await rootBundle.loadString('assets/dummy.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      // 에러 처리
      print("Error loading dummy books: $e");
      return [];
    }
  }
}

class NewBookService {
  // 도서 검색
  static Future<List<Book>> fetchNewBooks() async {
    try {
      final String response = await rootBundle.loadString('assets/new.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      // 에러 처리
      print("Error loading new books: $e");
      return [];
    }
  }
}
