import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:yeowoobi_frontend/sns/models/sns_post.dart';
import 'package:yeowoobi_frontend/sns/screens/sns_detail_screen.dart';

class SnsScreen extends StatefulWidget {
  const SnsScreen({super.key});

  @override
  State<SnsScreen> createState() => _SnsScreenState();
}

class _SnsScreenState extends State<SnsScreen> {
  List<SnsPost> posts = [];
  List<bool> isLikedList = [];
  List<int> likeCountList = [];
  bool _showReview = false;
  SnsPost? _selectedPost;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    final String jsonString = await rootBundle.loadString('lib/sns/sns_dummy.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    final List<SnsPost> loadedPosts = jsonList.map((json) => SnsPost.fromJson(json)).toList();

    setState(() {
      posts = loadedPosts;
      isLikedList = List<bool>.filled(posts.length, false);
      likeCountList = posts.map((e) => e.likes).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: CustomTheme.backgroundColor(context),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
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
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final isLiked = isLikedList[index];
                      final likeCount = likeCountList[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SnsDetailScreen(post: post)),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16, top: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 24),
                                    Text(post.bookTitle, style: const TextStyle(fontSize: 12, color: CustomTheme.neutral300)),
                                    const SizedBox(height: 4),
                                    Text(post.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const CircleAvatar(radius: 12, backgroundColor: CustomTheme.neutral200),
                                        const SizedBox(width: 8),
                                        Text(post.uploader, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                        const Spacer(),
                                        Text(post.time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(post.feedImage),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isLikedList[index] = !isLiked;
                                              likeCountList[index] += isLiked ? -1 : 1;
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset('assets/icons/heart.png', width: 18, color: isLiked ? cs.primary : null),
                                              const SizedBox(width: 4),
                                              SizedBox(
                                                width: 20,
                                                height: 16,
                                                child: likeCount > 0
                                                    ? Text('$likeCount', style: TextStyle(color: isLiked ? cs.primary : Colors.black))
                                                    : const SizedBox.shrink(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Image.asset('assets/icons/chat.png', width: 18, height: 18),
                                        const SizedBox(width: 4),
                                        Text('${post.comments}'),
                                        const Spacer(),
                                        Image.asset('assets/icons/star.png', width: 18, height: 18),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 24,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    _showReview = true;
                                    _selectedPost = post;
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4C443B),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset('assets/icons/write.png', width: 12, height: 12, color: Colors.white),
                                        const SizedBox(width: 4),
                                        const Text('한 줄 리뷰', style: TextStyle(color: Colors.white, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_showReview && _selectedPost != null)
            GestureDetector(
              onTap: () => setState(() => _showReview = false),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Container(
                      width: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFF59E),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Text(
                              '"${_selectedPost!.review}"',
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFFDE7),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    _selectedPost!.coverImage,
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_selectedPost!.bookTitle,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const Text('프란치스카 비어만',
                                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}