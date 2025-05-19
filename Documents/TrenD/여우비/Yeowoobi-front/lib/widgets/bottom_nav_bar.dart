import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/assets/theme/custom_theme.dart'; // ✅ 테마 가져오기

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar(
      {required this.currentIndex, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // ✅ 현재 테마 가져오기
    final bool isDarkMode = theme.brightness == Brightness.dark; // ✅ 다크 모드 확인

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor:
          isDarkMode ? Colors.black : Colors.white, // ✅ 다크/라이트 모드별 배경색
      selectedItemColor: isDarkMode
          ? CustomTheme.darkPrimaryColor
          : CustomTheme.lightPrimaryColor, // ✅ 선택된 아이콘 & 라벨 색상
      unselectedItemColor: isDarkMode
          ? CustomTheme.darkSecondaryColor
          : CustomTheme.lightSecondaryColor, // ✅ 선택되지 않은 아이콘 & 라벨 색상
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold, // ✅ 선택된 라벨 가독성 강화
        color: isDarkMode
            ? CustomTheme.darkPrimaryColor
            : CustomTheme.lightPrimaryColor,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500, // ✅ 선택되지 않은 라벨 가독성 강화
        color: isDarkMode
            ? CustomTheme.darkSecondaryColor
            : CustomTheme.lightSecondaryColor,
      ),
      type: BottomNavigationBarType.fixed, // ✅ 아이콘 움직임 없이 고정
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.book), label: "독서록"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "SNS"),
        BottomNavigationBarItem(icon: Icon(Icons.forum), label: "게시판"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "설정"),
      ],
    );
  }
}
