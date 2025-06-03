import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:yeowoobi_frontend/board/screens/board_detail_screen.dart';
import 'package:yeowoobi_frontend/board/screens/board_create_screen.dart';

// ✅ BoardCreateScreen에서 가져온 anonymousPosts 맵
import 'package:yeowoobi_frontend/board/screens/board_create_screen.dart' show anonymousPosts;

class FreeBoardScreen extends StatefulWidget {
  const FreeBoardScreen({super.key});

  @override
  State<FreeBoardScreen> createState() => _FreeBoardScreenState();
}

class _FreeBoardScreenState extends State<FreeBoardScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _indicatorAnim;

  final List<String> tabs = ['최신글', '인기글'];
  List<dynamic> posts = [];

  final String _apiUrl = 'http://43.202.170.189:3000/community/posts';
  final String _token =
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjA3NjY1MTE4LTcxN2EtNGVjZC05MDZmLTllYWQyYTIyYzkzYiIsImlhdCI6MTc0ODc1NjAzMywiZXhwIjoxNzUxMzQ4MDMzfQ.X7RpYpkDoii2ucukfeW99k3Xu2ddGvRnEjHw4jgu3hA';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _indicatorAnim = Tween<double>(begin: 0, end: 0).animate(_controller);
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final response = await http.get(
      Uri.parse(_apiUrl),
      headers: {
        'Authorization': _token,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      data.sort((a, b) {
        final aTime = DateTime.parse(a['createdAt']);
        final bTime = DateTime.parse(b['createdAt']);
        return bTime.compareTo(aTime);
      });

      setState(() {
        posts = data;
      });
    } else {
      debugPrint('불러오기 실패: ${response.statusCode}');
    }
  }

  String getRelativeTime(String isoTime) {
    final DateTime postTime = DateTime.parse(isoTime);
    final Duration diff = DateTime.now().difference(postTime);

    if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else {
      return '${diff.inDays}일 전';
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _indicatorAnim = Tween<double>(
        begin: _selectedIndex.toDouble(),
        end: index.toDouble(),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.forward(from: 0);
      _selectedIndex = index;

      if (index == 0) {
        posts.sort((a, b) =>
            DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));
      } else {
        posts.sort((a, b) => b['likesCount'].compareTo(a['likesCount']));
      }
    });
  }

  Color _likeColor() {
    return CustomTheme.neutral400;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(tabs.length, (index) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _onTabTapped(index),
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            children: [
                              Text(
                                tabs[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedIndex == index
                                      ? Colors.black
                                      : CustomTheme.neutral300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(tabs.length, (index) {
                      return Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 2,
                          color: _selectedIndex == index
                              ? cs.primary
                              : CustomTheme.neutral100,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadPosts,
                child: Container(
                  color: Colors.white,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Divider(
                        height: 32,
                        thickness: 1,
                        color: CustomTheme.neutral100,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final postId = post['id'];
                      final nickname = (anonymousPosts[postId] == true)
                          ? '익명'
                          : (post['authorNickname'] ?? '익명');

                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BoardDetailScreen(post: post),
                            ),
                          );
                          if (result != null) {
                            if (result is Map && result['deletedPostId'] != null) {
                              setState(() {
                                posts.removeWhere((p) => p['id'] == result['deletedPostId']);
                              });
                            } else if (result is Map) {
                              setState(() {
                                posts[index]['commentsCount'] = result['commentsCount'];
                                posts[index]['likesCount'] = result['likesCount'];
                                posts[index]['isLiked'] = result['isLiked'];
                              });
                            } else {
                              await _loadPosts();
                            }
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: CustomTheme.neutral400,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    post['content'],
                                    style: const TextStyle(
                                      color: CustomTheme.neutral300,
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '$nickname · ${getRelativeTime(post['createdAt'])}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: CustomTheme.neutral200,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/heart.png',
                                        width: 18,
                                        color: _likeColor(),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${post['likesCount']}',
                                        style: TextStyle(
                                          color: _likeColor(),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Image.asset(
                                        'assets/icons/chat.png',
                                        width: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text('${post['commentsCount']}'),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 24,
          right: 20,
          child: GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BoardCreateScreen(),
                ),
              );
              _loadPosts();
            },
            child: AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 100),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/write.png',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}