import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class BookWriteScreen extends StatefulWidget {
  const BookWriteScreen({super.key});

  @override
  _BookWriteScreenState createState() => _BookWriteScreenState();
}

class _BookWriteScreenState extends State<BookWriteScreen> {
  late final QuillController _controller;
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
    _controller.document = Document()..insert(0, 'Start writing your notes...');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_editorFocusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorScrollController.dispose();
    _editorFocusNode.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.neutral100,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            // Title Input and Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '제목을 입력하세요!',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: CustomTheme.neutral200,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(thickness: 0.5, color: CustomTheme.neutral300),
            // Editor 영역 - Expanded
            Expanded(
              child: QuillEditor(
                focusNode: _editorFocusNode,
                scrollController: _editorScrollController,
                controller: _controller,
                config: QuillEditorConfig(
                  placeholder: '책을 읽고 어떤 생각이 들었나요?',
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
            // Toolbar 영역
            Container(
              height: 56,
              color: CustomTheme.neutral100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    QuillToolbarHistoryButton(
                      isUndo: true,
                      controller: _controller,
                    ),
                    QuillToolbarHistoryButton(
                      isUndo: false,
                      controller: _controller,
                    ),
                    QuillToolbarToggleStyleButton(
                      options: const QuillToolbarToggleStyleButtonOptions(),
                      controller: _controller,
                      attribute: Attribute.bold,
                    ),
                    QuillToolbarToggleStyleButton(
                      options: const QuillToolbarToggleStyleButtonOptions(),
                      controller: _controller,
                      attribute: Attribute.italic,
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: _controller,
                      attribute: Attribute.underline,
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: _controller,
                      attribute: Attribute.strikeThrough,
                    ),
                    QuillToolbarSelectHeaderStyleDropdownButton(
                      controller: _controller,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
