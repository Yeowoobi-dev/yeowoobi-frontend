import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../models/logData.dart';
import '../models/simpleLogData.dart';

// 내 독서록 목록 호출 API GET 요청
class MyBookLogService {
  static Future<List<SimpleLogData>> fetchMySimpleLogs() async {
    final url = Uri.parse('http://43.202.170.189:3000/book-logs/log');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImExOTY1MjE1LWRkZDUtNDBlNS04NjZmLTQyNDMxZWE4OGE0ZCIsImlhdCI6MTc0ODc0OTk4MCwiZXhwIjoxNzUxMzQxOTgwfQ.2unp5SCwOVZwpQXX2-cbW1YEM7rttWTORS4W9qR-JaI',
        },
      );

      // 디버깅용 로그 from book_service.dart
      print('Status Code (My Logs): ${response.statusCode}');
      print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final dynamic rawData = jsonBody['data'];
        if (rawData is List) {
          return rawData.map((item) => SimpleLogData.fromJson(item)).toList();
        } else if (rawData is Map<String, dynamic>) {
          return [SimpleLogData.fromJson(rawData)];
        } else {
          print("Unexpected type for data: ${rawData.runtimeType}");
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('내 독서록 API 실패: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching my logs: $e");
      return [];
    }
  }
}

// 도서 검색 API GET 요청
class NewBookService {
  static Future<List<Book>> fetchNewBooks(String keyword) async {
    final url = Uri.parse(
        'http://43.202.170.189:3000/book-logs/search?query=$keyword&display=10&start=1');

    try {
      final response = await http.get(
        url,
        headers: {
          //'Authorization': 'Bearer ${dotenv.env['BEARER_TOKEN']}',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImExOTY1MjE1LWRkZDUtNDBlNS04NjZmLTQyNDMxZWE4OGE0ZCIsImlhdCI6MTc0ODc0OTk4MCwiZXhwIjoxNzUxMzQxOTgwfQ.2unp5SCwOVZwpQXX2-cbW1YEM7rttWTORS4W9qR-JaI',
        },
      );

      // 디버깅용 로그 from book_service.dart
      print('Status Code: ${response.statusCode} frrom 도서 검색 API');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final List<dynamic> items = jsonBody['data']['items'];

        return items
            .map((item) => Book(
                  id: '', // id는 사용하지 않음
                  title: item['title'] ?? '',
                  author: item['author'] ?? '',
                  imageUrl: item['image'] ?? '',
                ))
            .toList();
      } else {
        throw Exception('도서 검색 API 실패: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching books from API: $e");
      return [];
    }
  }
}

// 독서록 작성 POST 요청
class NewBookLogSPost {
  static Future<bool> postBookLog(Map<String, dynamic> logData) async {
    final url = Uri.parse('http://43.202.170.189:3000/book-logs/log');

    print('POST URL: $url');
    print('jsonEncode(logData) to server: ${jsonEncode(logData)}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImExOTY1MjE1LWRkZDUtNDBlNS04NjZmLTQyNDMxZWE4OGE0ZCIsImlhdCI6MTc0ODc0OTk4MCwiZXhwIjoxNzUxMzQxOTgwfQ.2unp5SCwOVZwpQXX2-cbW1YEM7rttWTORS4W9qR-JaI',
      },
      body: jsonEncode(logData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('독서록 작성 POST 성공');
      return true;
    } else {
      print('독서록 작성 POST 실패: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('POST 실패');
    }
  }
}

// 단일 독서록 조회 API GET 요청
class BookLogDetailService {
  static Future<LogData?> fetchLogDetail(int id) async {
    final url = Uri.parse('http://43.202.170.189:3000/book-logs/log/$id');
    print('Fetching log detail from URL: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImExOTY1MjE1LWRkZDUtNDBlNS04NjZmLTQyNDMxZWE4OGE0ZCIsImlhdCI6MTc0ODc0OTk4MCwiZXhwIjoxNzUxMzQxOTgwfQ.2unp5SCwOVZwpQXX2-cbW1YEM7rttWTORS4W9qR-JaI',
        },
      );

      print('Status Code (Log Detail): ${response.statusCode}');
      print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final Map<String, dynamic> data = jsonBody['data'];
        return LogData.fromJson(data);
      } else {
        throw Exception('단일 독서록 API 실패: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching log detail: $e");
      return null;
    }
  }
}
