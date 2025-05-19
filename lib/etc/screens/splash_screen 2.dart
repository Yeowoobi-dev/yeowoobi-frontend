import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:yeowoobi_frontend/etc/screens/login_screen.dart';
import 'package:yeowoobi_frontend/etc/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      // ✅ 2초 후 로그인 화면으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 현재 테마 가져오기
    final bool isDarkMode = theme.brightness == Brightness.dark; // ✅ 다크 모드 확인
    final Color backgroundColor = isDarkMode
        ? CustomTheme.darkPrimaryColor // 다크 모드 배경색
        : CustomTheme.lightPrimaryColor; // 라이트 모드 배경색

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/logo_white.png',
              width: 150,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              "여우비",
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "여기, 우리들의 비밀 책장",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
