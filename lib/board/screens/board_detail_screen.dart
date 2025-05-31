import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'comment_tile.dart';
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
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjA3NjY1MTE4LTcxN2EtNGVjZC05MDZmLTllYWQyYTIyYzkzYiIsImlhdCI6MTc0ODY2Nzk3NywiZXhwIjoxNzQ4NjcxNTc3fQ.4zImnvne7m_BNdL0RXDu949w1T1ArKx6TcbaxZGEvls';
  final String currentUserId = '07665118-717a-4ecd-906f-9ead2a22c93b';

  @override
  void initState() {
    super.initState();
    _loadPost(); // ✅ 게시물 최신 상태
    _loadComments(); // 댓글 로드
  }

  Future<void> _loadPost() async {
    final postId = widget.post['id'];
    final response = await http.get(
      Uri.parse('http://43.202.170.189:3000/community/posts/$postId/like/status'),
      headers: {'Authorization': _token},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      setState(() {
        likeCount = widget.post['likesCount'] ?? 0;
        isLiked = data['isLiked'] ?? false;
      });
    } else {
      debugPrint('게시물 로드 실패: ${response.statusCode}');
    }
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

    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });

    try {
      final response = await http.post(
        Uri.parse('http://43.202.170.189:3000/community/posts/$postId/like'),
        headers: {'Authorization': _token},
      );

      if (response.statusCode != 200) {
        setState(() {
          isLiked = !isLiked;
          likeCount += isLiked ? 1 : -1;
        });
      }
    } catch (e) {
      setState(() {
        isLiked = !isLiked;
        likeCount += isLiked ? 1 : -1;
      });
      debugPrint('좋아요 실패: $e');
    }
  }

  Future<void> _submitComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final postId = widget.post['id'];
    final body = {
      'content': text,
      'isAnonymous': isAnonymous,
    };

    if (replyTarget != null) {
      body['parentId'] = replyTarget!['id'];
    }

    final response = await http.post(
      Uri.parse('http://43.202.170.189:3000/community/posts/$postId/comments'),
      headers: {
        'Authorization': _token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      _controller.clear();
      replyTarget = null;
      await _loadComments();
    } else {
      debugPrint('댓글 작성 실패: ${response.statusCode}');
    }
  }

  Future<void> _deleteComment(int commentId) async {
    final response = await http.delete(
      Uri.parse('http://43.202.170.189:3000/community/comments/$commentId'),
      headers: {'Authorization': _token},
    );

    if (response.statusCode == 200) {
      await _loadComments();
    } else {
      debugPrint('댓글 삭제 실패: ${response.body}');
    }
  }

  Future<void> _deletePost() async {
    final postId = widget.post['id'];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('게시글 삭제'),
        content: const Text('정말로 이 게시글을 삭제하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('삭제')),
        ],
      ),
    );

    if (confirmed != true) return;

    final response = await http.delete(
      Uri.parse('http://43.202.170.189:3000/community/posts/$postId'),
      headers: {'Authorization': _token},
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      debugPrint('게시물 삭제 실패: ${response.body}');
    }
  }

  int _countTotalComments() {
    return comments.fold(0, (sum, c) => sum + 1 + ((c['children']?.length ?? 0) as int));
  }

  String _formatDate(String isoTime) {
    final date = DateTime.parse(isoTime);
    return '${date.month}.${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: [
          if (widget.post['authorId'] == currentUserId)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deletePost,
            )
        ],
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
                              width: 20,
                              color: isLiked ? cs.primary : CustomTheme.neutral300,
                            ),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 20,
                              child: likeCount > 0
                                  ? Text(
                                '$likeCount',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isLiked ? cs.primary : CustomTheme.neutral300,
                                ),
                              )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Image.asset('assets/icons/chat.png', width: 20),
                      const SizedBox(width: 6),
                      Text('${_countTotalComments()}', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(thickness: 1.2, color: CustomTheme.neutral100),
                  const SizedBox(height: 16),
                  ...comments.map((comment) {
                    return CommentTile(
                      comment: comment,
                      currentUserId: currentUserId,
                      onReply: (target) => setState(() => replyTarget = target),
                      onLike: (id) async {
                        await http.post(
                          Uri.parse('http://43.202.170.189:3000/community/comments/$id/like'),
                          headers: {'Authorization': _token},
                        );
                        await _loadComments();
                      },
                      onDelete: (id) async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('댓글 삭제'),
                            content: const Text('정말로 이 댓글을 삭제하시겠습니까?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('삭제')),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await _deleteComment(id);
                        }
                      },
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
                    child: Text(
                      '답글 대상: ${replyTarget!['username'] ?? '익명'}',
                      style: const TextStyle(fontSize: 13, color: CustomTheme.neutral300),
                    ),
                  ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
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