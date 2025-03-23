import 'package:flutter/material.dart';

class CustomTheme {
  // ✅ 기본 색상 설정 (라이트 & 다크 모드)
  static const Color lightPrimaryColor = Color(0xFFF2763F);
  static const Color lightSecondaryColor = Color(0xFFFDDDD0);
  static const Color darkPrimaryColor = Colors.white;
  static const Color darkSecondaryColor = Color(0xFFB0B0B0);
  static const Color mainBackgroundColor = Color(0xFFF6F4F1);

  // ✅ 공통 Typography 설정
  static const TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(
        fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    headlineSmall: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
    bodySmall: TextStyle(fontSize: 12, color: Colors.black45),
    labelLarge: TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
  );

  // ✅ Light Theme 설정
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    colorScheme: ColorScheme.light(
      primary: lightPrimaryColor,
      secondary: lightSecondaryColor,
    ),
    textTheme: textTheme,

    // ✅ AppBar 스타일
    appBarTheme: AppBarTheme(
      backgroundColor: lightPrimaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: textTheme.headlineSmall?.copyWith(color: Colors.white),
    ),

    // ✅ 버튼 스타일
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: textTheme.labelLarge,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightPrimaryColor,
        side: BorderSide(color: lightPrimaryColor),
        textStyle: textTheme.labelLarge,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightPrimaryColor,
        textStyle: textTheme.labelLarge,
      ),
    ),

    // ✅ FloatingActionButton 스타일
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightPrimaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // ✅ 입력 필드 스타일
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightPrimaryColor)),
      hintStyle: textTheme.bodyMedium,
    ),

    // ✅ 아이콘 스타일
    iconTheme: const IconThemeData(color: Colors.black87, size: 24),
  );

  // ✅ Dark Theme 설정
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    colorScheme: ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: darkSecondaryColor,
    ),
    textTheme:
        textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),

    // ✅ AppBar 스타일
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: textTheme.headlineSmall?.copyWith(color: Colors.white),
    ),

    // ✅ 버튼 스타일 (다크 모드)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: textTheme.labelLarge?.copyWith(color: Colors.black),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkPrimaryColor,
        side: BorderSide(color: darkPrimaryColor),
        textStyle: textTheme.labelLarge,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkPrimaryColor,
        textStyle: textTheme.labelLarge,
      ),
    ),

    // ✅ FloatingActionButton 스타일 (다크 모드)
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkPrimaryColor,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // ✅ 입력 필드 스타일 (다크 모드)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkPrimaryColor)),
      hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.white70),
    ),

    // ✅ 아이콘 스타일 (다크 모드)
    iconTheme: const IconThemeData(color: Colors.white, size: 24),
  );
}
