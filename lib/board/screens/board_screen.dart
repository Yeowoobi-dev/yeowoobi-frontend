import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/board/screens/free_board_screen.dart';
import 'package:yeowoobi_frontend/board/screens/debate_board_screen.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SafeArea(
      child: Column(
        children: [
          // 상단 로고 + 아이콘
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/image/logo_orange.png', height: 36),
                Row(
                  children: [
                    IconButton(
                      icon: const ImageIcon(AssetImage('assets/icons/user.png')),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const ImageIcon(AssetImage('assets/icons/search.png')),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const ImageIcon(AssetImage('assets/icons/notify.png')),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: CustomTheme.neutral100),

          // 자유게시판 / 토론게시판 텍스트 탭
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _tabController.animateTo(0),
                  child: Text(
                    '자유게시판',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _tabController.index == 0
                          ? Colors.black
                          : CustomTheme.neutral300,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => _tabController.animateTo(1),
                  child: Text(
                    '토론게시판',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _tabController.index == 1
                          ? Colors.black
                          : CustomTheme.neutral300,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: CustomTheme.neutral100),

          // 탭 화면
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                FreeBoardScreen(),
                DebateBoardScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}