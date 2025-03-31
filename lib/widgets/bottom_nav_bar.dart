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
        fontWeight: FontWeight.bold,
      ),
      items: List.generate(4, (index) {
        final icons = [
          'assets/icons/category.png',
          'assets/icons/sns.png',
          'assets/icons/board.png',
          'assets/icons/setting.png',
        ];
        final labels = ['독서록', 'SNS', '게시판', '설정'];
        return BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage(icons[index]),
            color: currentIndex == index
                ? colorScheme.primary
                : CustomTheme.neutral200,
          ),
          label: labels[index],
        );
      }),
    );
  }
}
