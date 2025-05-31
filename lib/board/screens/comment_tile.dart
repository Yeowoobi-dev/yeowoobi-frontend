import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class CommentTile extends StatelessWidget {
  final Map<String, dynamic> comment;
  final String currentUserId;
  final Map<String, dynamic>? replyTarget;
  final Future<void> Function(Map<String, dynamic>) onReply;
  final Future<void> Function(int) onLike;
  final Future<void> Function(int) onDelete;

  const CommentTile({
    super.key,
    required this.comment,
    required this.currentUserId,
    required this.replyTarget,
    required this.onReply,
    required this.onLike,
    required this.onDelete,
  });

  String _format(String isoTime) {
    final date = DateTime.parse(isoTime);
    return '${date.month}.${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isMine = comment['userId'] == currentUserId;
    final isLiked = comment['isLiked'] ?? false;
    final likesCount = comment['likesCount'] ?? 0;
    final replies = comment['children'] ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 댓글 (상위)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
          const SizedBox(height: 8),
          Text(comment['content'], style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  await onLike(comment['id']);
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/heart.png',
                      width: 18,
                      color: isLiked
                          ? Theme.of(context).colorScheme.primary
                          : CustomTheme.neutral300,
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 20,
                      child: likesCount > 0
                          ? Text(
                        '$likesCount',
                        style: TextStyle(
                          fontSize: 14,
                          color: isLiked
                              ? Theme.of(context).colorScheme.primary
                              : CustomTheme.neutral300,
                        ),
                        textAlign: TextAlign.center,
                      )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => onReply(comment),
                child: Row(
                  children: [
                    Image.asset('assets/icons/chat.png', width: 18),
                    const SizedBox(width: 4),
                    Text(
                      '답글',
                      style: TextStyle(
                        fontSize: 14,
                        color: replyTarget?['id'] == comment['id']
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (isMine)
                GestureDetector(
                  onTap: () async {
                    await onDelete(comment['id']);
                  },
                  child: Row(
                    children: [
                      Image.asset('assets/icons/delete.png', width: 18),
                      const SizedBox(width: 4),
                      const Text('삭제', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // 답글
          ...replies.map<Widget>((reply) {
            final isReplyMine = reply['userId'] == currentUserId;
            final replyLiked = reply['isLiked'] ?? false;
            final replyLikesCount = reply['likesCount'] ?? 0;
            return Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.subdirectory_arrow_right,
                          size: 16, color: CustomTheme.neutral300),
                      const SizedBox(width: 6),
                      const CircleAvatar(radius: 14, backgroundColor: CustomTheme.neutral200),
                      const SizedBox(width: 10),
                      const Text('익명', style: TextStyle(fontSize: 16)),
                      const Spacer(),
                      Text(
                        _format(reply['createdAt']),
                        style: const TextStyle(fontSize: 13, color: CustomTheme.neutral300),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(reply['content'], style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await onLike(reply['id']);
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/heart.png',
                              width: 16,
                              color: replyLiked
                                  ? Theme.of(context).colorScheme.primary
                                  : CustomTheme.neutral300,
                            ),
                            const SizedBox(width: 4),
                            SizedBox(
                              width: 20,
                              child: replyLikesCount > 0
                                  ? Text(
                                '$replyLikesCount',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: replyLiked
                                      ? Theme.of(context).colorScheme.primary
                                      : CustomTheme.neutral300,
                                ),
                                textAlign: TextAlign.center,
                              )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (isReplyMine)
                        GestureDetector(
                          onTap: () async {
                            await onDelete(reply['id']);
                          },
                          child: Row(
                            children: [
                              Image.asset('assets/icons/delete.png', width: 16),
                              const SizedBox(width: 4),
                              const Text('삭제', style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}