import 'package:flutter/material.dart';

class CustomTheme {
  // 라이트 모드 색상
  static const Color lightPrimaryColor = Color(0xFFF2763F); // 메인 컬러
  static const Color lightSecondaryColor = Color(0xFFE2571A); // 서브 컬러
  static const Color lightTertiaryColor = Color(0xFF863F1F); // 세번째 컬러
  static const Color lightBackgroundColor = Color(0xFFF6F4F1); // 배경 컬러

  // 다크 모드 색상
  static const Color darkPrimaryColor = Colors.white; // 메인 컬러
  static const Color darkSecondaryColor = Color(0xFFB0B0B0); // 서브 컬러
  static const Color darkTertiaryColor = Color(0xFF696462); // 세번째 컬러
  static const Color darkBackgroundColor = Color(0xFF4C443B); // 배경 컬러

  // 중립 색상
  static const Color white = Color(0xFFEEEAE6); // white
  static const Color neutral100 = Color(0xFFEEEAE6); // gray100
  static const Color neutral200 = Color(0xFFA4A2A0); // gray200
  static const Color neutral300 = Color(0xFF696462); // gray300
  static const Color neutral400 = Color(0xFF4C443B); // gray400
  static const Color black = Color(0xFF110000); // black

  static Color backgroundColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? darkBackgroundColor
        : lightBackgroundColor;
  }

  // 라이트 테마
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackgroundColor,
    colorScheme: const ColorScheme.light(
      primary: lightPrimaryColor,
      secondary: lightSecondaryColor,
      tertiary: lightTertiaryColor,
      shadow: neutral200,
    ),
  );

  // 다크 테마
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackgroundColor,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: darkSecondaryColor,
      tertiary: darkTertiaryColor,
      shadow: neutral200,
    ),
  );
}
