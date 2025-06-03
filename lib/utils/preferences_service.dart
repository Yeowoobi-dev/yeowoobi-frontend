import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static Future<void> saveNickname(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nickname', nickname);
  }

  static Future<String?> getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nickname');
  }

  static Future<void> removeNickname() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('nickname');
  }
}