import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: CustomTheme.neutral200,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      items: const [
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/category.png')),
            label: "독서록"),
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/sns.png')), label: "SNS"),
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/board.png')),
            label: "게시판"),
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/setting.png')),
            label: "설정"),
      ],
    );
  }
}
