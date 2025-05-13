import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/book_log/models/template.dart';

class TemplateEditScreen extends StatefulWidget {
  final Template template;

  const TemplateEditScreen({super.key, required this.template});

  @override
  State<TemplateEditScreen> createState() => _TemplateEditScreenState();
}

class _TemplateEditScreenState extends State<TemplateEditScreen> {
  late TextEditingController _titleController;
  late List<TextEditingController> _contentControllers;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.template.name);
    _contentControllers = widget.template.contents.map((e) {
      return TextEditingController(text: e['insert']?.toString().trim() ?? '');
    }).toList();
  }

  void _addNewSection() {
    setState(() {
      _contentControllers.add(TextEditingController());
    });
  }

  void _saveTemplate() {
    final updatedTemplate = Template(
      id: widget.template.id,
      userId: widget.template.userId,
      name: _titleController.text,
      contents:
          _contentControllers.map((c) => {'insert': '${c.text}\n'}).toList(),
    );

    Navigator.pop(context, updatedTemplate);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('템플릿 수정'),
        actions: [
          TextButton(
            onPressed: _saveTemplate,
            child: const Text('저장', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '템플릿 제목'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: _contentControllers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return TextField(
                    controller: _contentControllers[index],
                    decoration: InputDecoration(labelText: '항목 ${index + 1}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addNewSection,
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('항목 추가'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final c in _contentControllers) {
      c.dispose();
    }
    super.dispose();
  }
}
