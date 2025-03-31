// book_log/services/book_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book.dart';

class BookService {
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
