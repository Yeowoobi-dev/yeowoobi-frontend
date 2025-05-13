import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:yeowoobi_frontend/book_log/models/template.dart';
import 'package:yeowoobi_frontend/book_log/services/template_service.dart';
import 'package:yeowoobi_frontend/book_log/screens/template_edit_screen.dart';

class TemplateSelectScreen extends StatefulWidget {
  const TemplateSelectScreen({super.key});

  @override
  State<TemplateSelectScreen> createState() => _TemplateSelectScreenState();
}

class _TemplateSelectScreenState extends State<TemplateSelectScreen> {
  late Future<List<Template>> _templatesFuture;

  @override
  void initState() {
    super.initState();
    _templatesFuture = TemplateService.fetchTemplates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('템플릿 선택'),
      ),
      body: FutureBuilder<List<Template>>(
        future: _templatesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('템플릿이 없습니다.'));
          } else {
            final templates = snapshot.data!;
            return ListView.builder(
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                return ListTile(
                  title: Text(template.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TemplateEditScreen(template: template),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
