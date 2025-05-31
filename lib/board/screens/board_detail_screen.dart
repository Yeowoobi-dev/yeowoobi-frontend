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
  bool _isDeleted = false;

  final String _token =
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjA3NjY1MTE4LTcxN2EtNGVjZC05MDZmLTllYWQyYTIyYzkzYiIsImlhdCI6MTc0ODY3MjY4NiwiZXhwIjoxNzUxMjY0Njg2fQ.1AZtrbziIH_MJ1upgJ1wAi0K5Zxdf32l7p9GQIaza3Q';

  @override
  void initState() {
    super.initState();
    _loadPost();
    _loadLikeStatus();
    _loadComments();
  }

  Future<void> _loadPost() async {
    final postId = widget.post['id'];
    final response = await http.get(
      Uri.parse('http://43.202.170.189:3000/community/posts/$postId'),
      headers: {'Authorization': _token},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      setState(() {
        likeCount = data['likesCount'];
        widget.post['likesCount'] = likeCount;
      });
    } else {
      debugPrint('게시물 로드 실패: ${response.statusCode}');
    }
  }

  Future<void> _loadLikeStatus() async {
    final postId = widget.post['id'];
    final response = await http.get(
      Uri.parse('http://43.202.170.189:3000/community/posts/$postId/like/status'),
      headers: {'Authorization': _token},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      setState(() {
        isLiked = data;
        widget.post['isLiked'] = isLiked;
      });
    } else {
      debugPrint('좋아요 상태 로드 실패: ${response.statusCode}');
    }
  }

  Future<void> _loadComments() async {
    final postId = widget.post['id'];
    final response = await http.get(
      Uri.parse('http://43.202.170.189:3000/community/posts/$postId/comments'),
      headers: {'Authorization': _token},
    );

    if (response.statusCode == 200) {
      List<dynamic> commentList = json.decode(response.body)['data'];

      for (var comment in commentList) {
        comment['isLiked'] = await _fetchCommentLikeStatus(comment['id']);
        if (comment['children'] != null) {
          for (var child in comment['children']) {
            child['isLiked'] = await _fetchCommentLikeStatus(child['id']);
          }
        }
      }

      setState(() {
        comments = commentList;
      });
    } else {
      debugPrint('댓글 불러오기 실패: ${response.statusCode}');
    }
  }

  Future<bool> _fetchCommentLikeStatus(int commentId) async {
    final response = await http.get(
      Uri.parse('http://43.202.170.189:3000/community/comments/$commentId/like'),
      headers: {'Authorization': _token},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return data;
    } else {
      debugPrint('댓글 좋아요 상태 불러오기 실패: ${response.statusCode}');
      return false;
    }
  }

  void _handleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
      widget.post['likesCount'] = likeCount;
      widget.post['isLiked'] = isLiked;
    });

    _sendLikeRequest();
  }

  Future<void> _sendLikeRequest() async {
    final postId = widget.post['id'];
    try {
      final response = await http.post(
        Uri.parse('http://43.202.170.189:3000/community/posts/$postId/like'),
        headers: {'Authorization': _token},
      );

      if (response.statusCode != 200) {
        debugPrint('좋아요 실패: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('좋아요 네트워크 실패: $e');
    }
  }

  Future<void> _submitComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final postId = widget.post['id'];
    final Map<String, dynamic> body = {
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
      _isDeleted = true;
      _returnUpdatedPost();
    } else {
      debugPrint('게시물 삭제 실패: ${response.body}');
    }
  }

  int _countTotalComments() {
    return comments.fold(0, (sum, c) => sum + 1 + ((c['children'] as List?)?.length ?? 0));
  }

  String _formatDate(String isoTime) {
    final date = DateTime.parse(isoTime);
    return '${date.month}.${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _returnUpdatedPost() {
    if (_isDeleted) {
      Navigator.pop(context, {'deletedPostId': widget.post['id']});
    } else {
      final updatedPost = {
        'commentsCount': _countTotalComments(),
        'likesCount': likeCount,
        'isLiked': isLiked,
      };
      Navigator.pop(context, updatedPost);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: () async {
        _returnUpdatedPost();
        return false;
      },
      child: Scaffold(
        backgroundColor: CustomTheme.backgroundColor(context),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Image.asset('assets/icons/back.png', width: 28),
            onPressed: _returnUpdatedPost,
          ),
          actions: [
            if (widget.post['authorId'] == '07665118-717a-4ecd-906f-9ead2a22c93b')
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: IconButton(
                  icon: Image.asset('assets/icons/delete.png', width: 24),
                  onPressed: _deletePost,
                ),
              ),
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
                          onTap: _handleLike,
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
                                  textAlign: TextAlign.center,
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
                        currentUserId: '07665118-717a-4ecd-906f-9ead2a22c93b',
                        replyTarget: replyTarget,
                        onReply: (target) {
                          setState(() {
                            if (replyTarget?['id'] == target['id']) {
                              replyTarget = null;
                            } else {
                              replyTarget = target;
                            }
                          });
                          return Future.value();
                        },
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
                            decoration: InputDecoration(
                              hintText: replyTarget == null ? '댓글을 입력해주세요.' : '답글을 입력해주세요.',
                              hintStyle: const TextStyle(fontSize: 16),
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
      ),
    );
  }
}