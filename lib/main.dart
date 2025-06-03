import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:yeowoobi_frontend/etc/screens/home_screen.dart';
import 'package:yeowoobi_frontend/etc/screens/login_screen.dart';
import 'package:yeowoobi_frontend/etc/screens/home_screen.dart';
import 'package:yeowoobi_frontend/etc/screens/splash_screen.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() {
  KakaoSdk.init(nativeAppKey: '1634174a8acc8c329f268e93b42f0f0b'); // 네이티브 키
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      title: 'Yeowoobi',
      darkTheme: CustomTheme.darkTheme,
      themeMode: ThemeMode.system,
      title: 'Yeowoobi',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
      ],
      //  iphone 기준으로 화면 크기 제한
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                maxWidth: 430, maxHeight: 932), // iPhone 14 Pro Max 기준
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      home: const HomeScreen(),
      home: SplashScreen(), // ✅ 닉네임 설정 화면부터
    );
  }
}
