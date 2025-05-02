import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/template.dart';

class TemplateService {
  // 현재는 로컬 JSON에서 불러오기
  static Future<List<Template>> fetchTemplates() async {
    try {
      final String response =
          await rootBundle.loadString('assets/template.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Template.fromJson(json)).toList();
    } catch (e) {
      print("Error loading templates: $e");
      return [];
    }
  }

  // API 연동 시 추가
}
