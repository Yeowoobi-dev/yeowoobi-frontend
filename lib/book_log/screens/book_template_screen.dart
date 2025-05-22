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
        backgroundColor: CustomTheme.backgroundColor(context),
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
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TemplateEditScreen(template: template),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            template.name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 16.0, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
