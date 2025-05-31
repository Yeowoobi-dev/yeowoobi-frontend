import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class BoardCreateScreen extends StatefulWidget {
  const BoardCreateScreen({super.key});

  @override
  State<BoardCreateScreen> createState() => _BoardCreateScreenState();
}

class _BoardCreateScreenState extends State<BoardCreateScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isAnonymous = true;

  final String _apiUrl = 'http://43.202.170.189:3000/community/posts';
  final String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjA3NjY1MTE4LTcxN2EtNGVjZC05MDZmLTllYWQyYTIyYzkzYiIsImlhdCI6MTc0ODY3MjY4NiwiZXhwIjoxNzUxMjY0Njg2fQ.1AZtrbziIH_MJ1upgJ1wAi0K5Zxdf32l7p9GQIaza3Q';

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 내용을 입력해주세요.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'title': title,
          'content': content,
          'isAnonymous': _isAnonymous,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.pop(context);
      } else {
        final message =
            jsonDecode(response.body)['message'] ?? '알 수 없는 오류가 발생했습니다.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('작성 실패: $message')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('작성 실패: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: CustomTheme.backgroundColor(context),
      appBar: AppBar(
        title: const Text('게시글 작성', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: '글 제목',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CustomTheme.neutral300,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const Divider(thickness: 1, color: CustomTheme.neutral100),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 16, height: 1.6),
                  decoration: const InputDecoration(
                    hintText:
                    '자유게시판 이용 규칙입니다.욕설, 비방 등의 표현을 사용하시면 처벌받을 수 있으니 주의해서 이용해 주세요.',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: CustomTheme.neutral300,
                      height: 1.6,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const Divider(thickness: 1, color: CustomTheme.neutral100),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomTheme.neutral200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image_outlined,
                      size: 24, color: CustomTheme.neutral300),
                ),
              ),
              const Divider(thickness: 1, color: CustomTheme.neutral100),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isAnonymous = !_isAnonymous),
                    child: Row(
                      children: [
                        Icon(
                          _isAnonymous
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: 18,
                          color: _isAnonymous
                              ? cs.primary
                              : CustomTheme.neutral200,
                        ),
                        const SizedBox(width: 6),
                        const Text('익명', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _submitPost,
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              '작성 완료',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}