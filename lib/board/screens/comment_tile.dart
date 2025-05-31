import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class CommentTile extends StatefulWidget {
  final Map<String, dynamic> comment;
  final String currentUserId;
  final Function(Map<String, dynamic>) onReply;
  final Function(int) onDelete;
  final Function(int) onLike; // ✅ 추가

  const CommentTile({
    super.key,
    required this.comment,
    required this.currentUserId,
    required this.onReply,
    required this.onDelete,
    required this.onLike,
  });

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool showReplies = false;

  String _format(String isoTime) {
    final date = DateTime.parse(isoTime);
    return '${date.month}.${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    final replies = comment['children'] ?? [];
    final isMine = comment['userId'] == widget.currentUserId;
    final likes = comment['likesCount'] ?? 0;
    final isLiked = comment['isLiked'] ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const CircleAvatar(radius: 14, backgroundColor: CustomTheme.neutral200),
            const SizedBox(width: 10),
            const Text('익명', style: TextStyle(fontSize: 16)),
            const Spacer(),
            Text(_format(comment['createdAt']),
                style: const TextStyle(fontSize: 14, color: CustomTheme.neutral300)),
          ]),
          const SizedBox(height: 8),
          Text(comment['content'], style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Row(children: [
            GestureDetector(
              onTap: () => widget.onLike(comment['id']),
              child: Row(children: [
                Image.asset(
                  'assets/icons/heart.png',
                  width: 18,
                  color: isLiked ? Theme.of(context).colorScheme.primary : CustomTheme.neutral300,
                ),
                const SizedBox(width: 4),
                if (likes > 0)
                  Text('$likes', style: TextStyle(
                    fontSize: 14,
                    color: isLiked ? Theme.of(context).colorScheme.primary : CustomTheme.neutral300,
                  )),
              ]),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => widget.onReply(comment),
              child: Row(children: [
                Image.asset('assets/icons/chat.png', width: 18),
                const SizedBox(width: 4),
                const Text('답글', style: TextStyle(fontSize: 14)),
              ]),
            ),
            const SizedBox(width: 16),
            if (isMine)
              GestureDetector(
                onTap: () => widget.onDelete(comment['id']),
                child: Row(children: [
                  Image.asset('assets/icons/delete.png', width: 18),
                  const SizedBox(width: 4),
                  const Text('삭제', style: TextStyle(fontSize: 14)),
                ]),
              ),
          ]),
          if (replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: GestureDetector(
                onTap: () => setState(() => showReplies = !showReplies),
                child: Text(
                  showReplies ? '답글 숨기기' : '답글 ${replies.length}개 보기',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
          if (showReplies)
            ...replies.map<Widget>((reply) {
              final replyLikes = reply['likesCount'] ?? 0;
              final isReplyMine = reply['userId'] == widget.currentUserId;
              final isReplyLiked = reply['isLiked'] ?? false;
              return Padding(
                padding: const EdgeInsets.only(left: 24, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.subdirectory_arrow_right, size: 16, color: CustomTheme.neutral300),
                      const SizedBox(width: 6),
                      const Text('익명', style: TextStyle(fontSize: 15)),
                      const Spacer(),
                      Text(
                        _format(reply['createdAt']),
                        style: const TextStyle(fontSize: 13, color: CustomTheme.neutral300),
                      ),
                    ]),
                    const SizedBox(height: 4),
                    Text(reply['content'], style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 4),
                    Row(children: [
                      GestureDetector(
                        onTap: () => widget.onLike(reply['id']),
                        child: Row(children: [
                          Image.asset(
                            'assets/icons/heart.png',
                            width: 16,
                            color: isReplyLiked ? Theme.of(context).colorScheme.primary : CustomTheme.neutral300,
                          ),
                          const SizedBox(width: 4),
                          if (replyLikes > 0)
                            Text('$replyLikes', style: TextStyle(
                              fontSize: 13,
                              color: isReplyLiked ? Theme.of(context).colorScheme.primary : CustomTheme.neutral300,
                            )),
                        ]),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => widget.onReply(reply),
                        child: Row(children: [
                          Image.asset('assets/icons/chat.png', width: 16),
                          const SizedBox(width: 4),
                          const Text('답글', style: TextStyle(fontSize: 13)),
                        ]),
                      ),
                      const SizedBox(width: 16),
                      if (isReplyMine)
                        GestureDetector(
                          onTap: () => widget.onDelete(reply['id']),
                          child: Row(children: [
                            Image.asset('assets/icons/delete.png', width: 16),
                            const SizedBox(width: 4),
                            const Text('삭제', style: TextStyle(fontSize: 13)),
                          ]),
                        ),
                    ]),
                  ],
                ),
              );
            }).toList()
        ],
      ),
    );
  }
}