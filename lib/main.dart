import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:yeowoobi_frontend/etc/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yeowoobi',
      theme: CustomTheme.lightTheme, // 라이트 테마 적용
      darkTheme: CustomTheme.darkTheme, // 다크 테마 적용
      themeMode: ThemeMode.system, // 시스템 설정
      home: SplashScreen(),
    );
  }
}
