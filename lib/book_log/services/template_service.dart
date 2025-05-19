import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/template.dart';

class TemplateService {
  static const String _filename = 'template.json';

  // 현재는 로컬 JSON에서 불러오기
  static Future<List<Template>> fetchTemplates() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final String response = await file.readAsString();
        final List<dynamic> data = json.decode(response);
        return data.map((json) => Template.fromJson(json)).toList();
      } else {
        // 최초 실행 시 assets 파일을 복사
        final String defaultData =
            await rootBundle.loadString('assets/template.json');
        await file.writeAsString(defaultData);
        final List<dynamic> data = json.decode(defaultData);
        return data.map((json) => Template.fromJson(json)).toList();
      }
    } catch (e) {
      print("Error loading templates: $e");
      return [];
    }
  }

  static Future<void> saveTemplates(List<Template> templates) async {
    try {
      final file = await _getLocalFile();
      final String jsonString =
          json.encode(templates.map((tpl) => tpl.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      print("Error saving templates: $e");
    }
  }

  static Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_filename');
  }
}
