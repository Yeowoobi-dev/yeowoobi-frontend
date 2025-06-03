import 'package:yeowoobi_frontend/recommendation/models/recommendedBook.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionsService {
  static Future<RecommendedBook> fetchRecommendedBooks(
      List<String> selectedAnswers) async {
    try {
      final url =
          Uri.parse('http://43.202.170.189:3001/book-recommendation/recommend');
      final payload = jsonEncode({'answers': selectedAnswers});
      print('POST URL: $url');
      print('POST Payload: $payload');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('API 응답 데이터: $data');
        return RecommendedBook.fromJson(data);
      } else {
        print('API 호출 실패 - 상태 코드: ${response.statusCode}');
        print('API 호출 실패 응답 내용: ${response.body}');
        throw Exception('책 추천 API 호출 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API 호출 중 예외 발생: $e');
      rethrow;
    }
  }
}
