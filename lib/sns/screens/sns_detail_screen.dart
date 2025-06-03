import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:yeowoobi_frontend/sns/models/sns_post_detail.dart';

class SnsDetailScreen extends StatefulWidget {
  final int postId;

  const SnsDetailScreen({super.key, required this.postId});

  @override
  State<SnsDetailScreen> createState() => _SnsDetailScreenState();
}

class _SnsDetailScreenState extends State<SnsDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _showCommentList = false;
  bool _isLoading = true;
  SnsPostDetail? postDetail;
  List<dynamic> comments = [];

  final String accessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjA3NjY1MTE4LTcxN2EtNGVjZC05MDZmLTllYWQyYTIyYzkzYiIsImlhdCI6MTc0ODc1NjAzMywiZXhwIjoxNzUxMzQ4MDMzfQ.X7RpYpkDoii2ucukfeW99k3Xu2ddGvRnEjHw4jgu3hA'; // 실제 토큰 입력

  @override
  void initState() {
    super.initState();
    loadPostDetail();
    loadComments();
  }

  Future<void> loadPostDetail() async {
    try {
      final response = await http.get(
        Uri.parse('http://43.202.170.189:3000/book-logs/log/sns/list'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        final matchedPost = data.firstWhere(
              (item) => item['id'] == widget.postId,
          orElse: () => null,
        );

        if (matchedPost != null) {
          setState(() {
            postDetail = SnsPostDetail.fromJson(matchedPost);
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> loadComments() async {
    try {
      final response = await http.get(
        Uri.parse('http://43.202.170.189:3000/book-logs/log/${widget.postId}/comment'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        setState(() {
          comments = data;
        });
      }
    } catch (e) {
      print('댓글 로딩 실패: $e');
    }
  }

  Future<void> submitComment() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('http://43.202.170.189:3000/book-logs/log/${widget.postId}/comment'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'content': content}),
      );

      if (response.statusCode == 201) {
        _controller.clear();
        loadComments(); // 작성 후 새로고침
        setState(() => _showCommentList = true); // 계속 댓글창 보여주기
      } else {
        print('댓글 작성 실패: ${response.body}');
      }
    } catch (e) {
      print('댓글 작성 중 에러: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFFAF8F3);

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: bgColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (postDetail == null) {
      return const Scaffold(
        backgroundColor: bgColor,
        body: Center(child: Text('데이터를 불러올 수 없습니다.')),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _showCommentList = false),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          leading: IconButton(
            icon: Image.asset('assets/icons/back.png', width: 24),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Column(
              children: [
                Divider(height: 1, thickness: 1, color: CustomTheme.neutral100),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 작성자
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundColor: CustomTheme.neutral200,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              postDetail!.userNickname,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // 제목
                        Text(
                          postDetail!.logTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                postDetail!.bookTitle,
                                style: const TextStyle(
                                  color: CustomTheme.neutral300,
                                ),
                              ),
                            ),
                            Text(
                              postDetail!.createdAt.split('T')[0].replaceAll('-', '/'),
                              style: const TextStyle(
                                color: CustomTheme.neutral300,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(thickness: 1, color: CustomTheme.neutral100),
                        const SizedBox(height: 20),
                        _buildRichText(postDetail!.text),
                      ],
                    ),
                  ),
                ),
                _buildCommentInput(bgColor),
              ],
            ),
            if (_showCommentList) _buildCommentListPopup(),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(List<dynamic> textBlocks) {
    List<Widget> widgets = [];
    bool isFirstSection = true;

    for (var block in textBlocks) {
      if (block is String) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              block,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),
        );
        continue;
      }
      final insert = block['insert'] ?? '';
      final attributes = block['attributes'] ?? {};

      if (attributes['bold'] == true) {
        if (!isFirstSection) {
          widgets.add(const SizedBox(height: 4));
        }
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Text(
              insert.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        isFirstSection = false;
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              insert.toString(),
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildCommentInput(Color bgColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: _showCommentList ? bgColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onTap: () => setState(() => _showCommentList = true),
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: '댓글을 입력해주세요.',
                  hintStyle: TextStyle(fontSize: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: submitComment,
              child: Image.asset('assets/icons/write.png', width: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentListPopup() {
    return GestureDetector(
      onTap: () => setState(() => _showCommentList = false),
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 100),
            width: MediaQuery.of(context).size.width - 32,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: comments.isEmpty
                ? const Text('댓글이 없습니다.')
                : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: comments.map((comment) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment['userNickname'] ?? '익명',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comment['content'] ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}