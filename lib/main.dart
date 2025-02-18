import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/assets/theme/custom_theme.dart';
import 'package:yeowoobi_frontend/etc/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yeowoobi',
      theme: CustomTheme.lightTheme, // ✅ 라이트 테마 적용
      darkTheme: CustomTheme.darkTheme, // ✅ 다크 테마 적용
      themeMode: ThemeMode.system, // ✅ 시스템 설정에 따라 다크/라이트 모드 자동 변경
      home: HomeScreen(),
    );
  }
}
