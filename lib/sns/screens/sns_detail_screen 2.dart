import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/sns/models/sns_post.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class SnsDetailScreen extends StatefulWidget {
  final SnsPost post;

  const SnsDetailScreen({super.key, required this.post});

  @override
  State<SnsDetailScreen> createState() => _SnsDetailScreenState();
}

class _SnsDetailScreenState extends State<SnsDetailScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _showCommentList = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFFFAF8F3);
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
            child: Divider(height: 1, thickness: 1, color: CustomTheme.neutral100),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                                radius: 16,
                                backgroundColor: CustomTheme.neutral200),
                            const SizedBox(width: 10),
                            Text(widget.post.uploader,
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(widget.post.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Text(widget.post.bookTitle,
                                  style: const TextStyle(
                                      color: CustomTheme.neutral300)),
                            ),
                            Text(widget.post.time,
                                style: const TextStyle(
                                    color: CustomTheme.neutral300)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5D1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          padding:
                          const EdgeInsets.fromLTRB(20, 24, 20, 20),
                          child: Text(
                            '"${widget.post.review}"',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFAEB),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          padding:
                          const EdgeInsets.fromLTRB(20, 14, 20, 14),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.asset(
                                  widget.post.coverImage,
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('책 먹는 여우',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  Text('프란치스카 비어만',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
                          onTap: () {},
                          child:
                          Image.asset('assets/icons/write.png', width: 24),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            if (_showCommentList)
              GestureDetector(
                onTap: () => setState(() => _showCommentList = false),
                child: Container(
                  color: Colors.transparent,
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: const Text(
                        '댓글 목록이 이곳에 표시됩니다.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}