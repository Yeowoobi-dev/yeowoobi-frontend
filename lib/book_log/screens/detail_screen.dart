import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String title = '';
  List<dynamic> contents = [];
  String? backgroundImage;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadLogData();
  }

  Future<void> _loadLogData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/log.json');

    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString);
      setState(() {
        title = data['title'] ?? '';
        final rawContents = data['contents'];
        contents = (rawContents is List && rawContents.isNotEmpty)
            ? rawContents
            : [
                {"insert": "\n"}
              ];
        backgroundImage = data['background'];
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final backgroundHeight = screenWidth * 1.414;
    final document = Document.fromDelta(Delta.fromJson(contents));
    final controller = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );
    final estimatedContentHeight =
        document.toPlainText().split('\n').length * 28.0 + 500;
    final repeatCount = (estimatedContentHeight / backgroundHeight).ceil();

    return Scaffold(
      backgroundColor: CustomTheme.neutral100,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Divider(
                thickness: 0.5, height: 1, color: CustomTheme.neutral200),
            Flexible(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: List.generate(repeatCount, (index) {
                        return backgroundImage != null
                            ? Image.asset(
                                backgroundImage!,
                                width: screenWidth,
                                height: backgroundHeight,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: screenWidth,
                                height: backgroundHeight,
                                color: CustomTheme.neutral100,
                              );
                      }),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                            thickness: 0.5, color: CustomTheme.neutral200),
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: QuillEditor(
                            controller: controller,
                            focusNode: FocusNode(
                                // 입력커서 없애서 읽기전용으로 만들기
                                skipTraversal: true,
                                canRequestFocus: false),
                            scrollController: ScrollController(),
                          ),
                        ),
                      ],
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
