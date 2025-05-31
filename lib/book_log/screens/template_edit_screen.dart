import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/book_log/models/template.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:yeowoobi_frontend/book_log/services/template_service.dart';

class TemplateEditScreen extends StatefulWidget {
  final Template template;

  const TemplateEditScreen({super.key, required this.template});

  @override
  State<TemplateEditScreen> createState() => _TemplateEditScreenState();
}

class _TemplateEditScreenState extends State<TemplateEditScreen> {
  late QuillController _controller;
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();
  final TextEditingController _titleController = TextEditingController();
  double? _currentFontSize;
  Attribute<dynamic> _currentAlignment = Attribute.leftAlignment;
  IconData _currentAlignmentIcon = Icons.format_align_left;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.template.name;
    final doc = Document.fromJson(widget.template.contents);
    _controller = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  void _saveTemplate() async {
    final updatedTemplate = Template(
      id: widget.template.id,
      userId: widget.template.userId,
      name: _titleController.text,
      contents: _controller.document.toDelta().toJson(),
    );

    final templates = await TemplateService.fetchTemplates();
    final index = templates.indexWhere((tpl) => tpl.id == updatedTemplate.id);
    if (index != -1) {
      templates[index] = updatedTemplate;
    }

    await TemplateService.saveTemplates(templates);

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.backgroundColor(context),
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('템플릿 수정'),
        backgroundColor: CustomTheme.backgroundColor(context),
        foregroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton(
              onPressed: _saveTemplate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                elevation: 0,
              ),
              child: const Text('저장'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: '템플릿 제목을 입력하세요',
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 20),
                      ),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child:
                        Divider(thickness: 0.5, color: CustomTheme.neutral200),
                  ),
                  QuillEditor(
                    focusNode: _editorFocusNode,
                    scrollController: _editorScrollController,
                    controller: _controller,
                    config:
                        const QuillEditorConfig(padding: EdgeInsets.all(18)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(thickness: 0.5, color: CustomTheme.neutral200),
          ),
          Container(
            height: 40,
            color: Colors.grey[100],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  QuillToolbarHistoryButton(
                      isUndo: true, controller: _controller),
                  QuillToolbarHistoryButton(
                      isUndo: false, controller: _controller),
                  QuillToolbarToggleStyleButton(
                      controller: _controller, attribute: Attribute.bold),
                  QuillToolbarToggleStyleButton(
                      controller: _controller, attribute: Attribute.italic),
                  QuillToolbarToggleStyleButton(
                      controller: _controller, attribute: Attribute.underline),
                  QuillToolbarToggleStyleButton(
                      controller: _controller,
                      attribute: Attribute.strikeThrough),
                  QuillToolbarToggleStyleButton(
                      controller: _controller, attribute: Attribute.blockQuote),
                  IconButton(
                    icon: Icon(_currentAlignmentIcon),
                    onPressed: () {
                      setState(() {
                        if (_currentAlignment == Attribute.leftAlignment) {
                          _currentAlignment = Attribute.centerAlignment;
                          _currentAlignmentIcon = Icons.format_align_center;
                        } else if (_currentAlignment ==
                            Attribute.centerAlignment) {
                          _currentAlignment = Attribute.rightAlignment;
                          _currentAlignmentIcon = Icons.format_align_right;
                        } else {
                          _currentAlignment = Attribute.leftAlignment;
                          _currentAlignmentIcon = Icons.format_align_left;
                        }
                        _controller.formatSelection(_currentAlignment);
                      });
                    },
                  ),
                  QuillToolbarColorButton(
                      controller: _controller, isBackground: false),
                  Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: DropdownButton<double>(
                      isDense: true,
                      underline: const SizedBox.shrink(),
                      hint: const Text('16'),
                      value: _currentFontSize,
                      items: [12, 14, 16, 18, 20, 24, 28].map((size) {
                        return DropdownMenuItem(
                          value: size.toDouble(),
                          child: Text('$size',
                              style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (size) {
                        if (size != null) {
                          setState(() {
                            _currentFontSize = size;
                            _controller.formatSelection(Attribute.fromKeyValue(
                                'size', size.toString()));
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
