import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class BoardDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const BoardDetailScreen({super.key, required this.post});

  @override
  State<BoardDetailScreen> createState() => _BoardDetailScreenState();
}

class _BoardDetailScreenState extends State<BoardDetailScreen> {
  bool isLiked = false;
  int likeCount = 0;
  bool isAnonymous = true;
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? replyTarget;

  List<dynamic> comments = [];
  final String _token =
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjA3NjY1MTE4LTcxN2EtNGVjZC05MDZmLTllYWQyYTIyYzkzYiIsImlhdCI6MTc0NzYzNzc4OCwiZXhwIjoxNzQ3NjQxMzg4fQ.i5G949cDRhPe6CLDVvx80xRWgR1XCgpy1tvEgCtu3LI';

  @override
  void initState() {
    super.initState();
    likeCount = widget.post['likesCount'] ?? 0;
    _loadComments();
  }

  Future<void> _loadComments() async {
    final postId = widget.post['id'];
    final response = await http.get(
      Uri.parse('http://43.202.170.189:3000/community/posts/$postId/comments'),
      headers: {'Authorization': _token},
    );

    if (response.statusCode == 200) {
      setState(() {
        comments = json.decode(response.body)['data'];
      });
    } else {
      debugPrint('댓글 불러오기 실패: ${response.statusCode}');
    }
  }

  Future<void> _handleLikeToggle() async {
    final postId = widget.post['id'];
    final response = await http.post(
      Uri.parse('http://43.202.170.189:3000/community/posts/$postId/like'),
      headers: {'Authorization': _token},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final success = responseBody['success'];
      if (success != null) {
        setState(() {
          isLiked = !isLiked;
          likeCount += isLiked ? 1 : -1;
        });
      }
    } else {
      debugPrint('좋아요 실패: ${response.statusCode}');
    }
  }

  String _formatDate(String isoTime) {
    final date = DateTime.parse(isoTime);
    return '${date.month}.${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _submitComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _controller.clear();
      replyTarget = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: CustomTheme.backgroundColor(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/icons/back.png', width: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 16, backgroundColor: CustomTheme.neutral200),
                      const SizedBox(width: 10),
                      const Text('익명', style: TextStyle(fontSize: 16)),
                      const Spacer(),
                      Text(
                        _formatDate(widget.post['createdAt']),
                        style: const TextStyle(fontSize: 14, color: CustomTheme.neutral300),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(widget.post['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    widget.post['content'],
                    style: const TextStyle(fontSize: 16, color: CustomTheme.neutral300, height: 1.6),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _handleLikeToggle,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/heart.png',
                              width: 22,
                              color: isLiked ? cs.primary : null,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$likeCount',
                              style: TextStyle(
                                fontSize: 16,
                                color: isLiked ? cs.primary : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Image.asset('assets/icons/chat.png', width: 22),
                      const SizedBox(width: 6),
                      Text('${comments.length}', style: const TextStyle(fontSize: 16)),
                      const Spacer(),
                      Image.asset('assets/icons/caution.png', width: 18),
                      const SizedBox(width: 6),
                      const Text('신고하기', style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(thickness: 1.2, color: CustomTheme.neutral100),
                  const SizedBox(height: 16),
                  ...comments.map((comment) {
                    return _CommentTile(
                      comment: comment,
                      onReply: (target) => setState(() => replyTarget = target),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1.2, color: CustomTheme.neutral100),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => setState(() => isAnonymous = !isAnonymous),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAnonymous ? Icons.check_box : Icons.check_box_outline_blank,
                        size: 18,
                        color: cs.primary,
                      ),
                      const SizedBox(width: 6),
                      const Text('익명', style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
                if (replyTarget != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 6),
                    child: Text('답글 대상: ${replyTarget!['username']}',
                        style: const TextStyle(fontSize: 13, color: CustomTheme.neutral300)),
                  ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
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
                        onTap: _submitComment,
                        child: Image.asset('assets/icons/write.png', width: 24),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final Map<String, dynamic> comment;
  final Function(Map<String, dynamic>) onReply;

  const _CommentTile({required this.comment, required this.onReply});

  String _format(String isoTime) {
    final date = DateTime.parse(isoTime);
    return '${date.month}.${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => onReply(comment),
            child: Row(
              children: [
                const CircleAvatar(radius: 14, backgroundColor: CustomTheme.neutral200),
                const SizedBox(width: 10),
                const Text('익명', style: TextStyle(fontSize: 16)),
                const Spacer(),
                Text(
                  _format(comment['createdAt']),
                  style: const TextStyle(fontSize: 14, color: CustomTheme.neutral300),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(comment['content'], style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}