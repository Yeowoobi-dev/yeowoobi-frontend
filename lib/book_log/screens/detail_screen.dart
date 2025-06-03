import 'dart:convert';
import 'dart:io';
import 'package:yeowoobi_frontend/book_log/services/book_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:yeowoobi_frontend/book_log/models/logData.dart';

class DetailScreen extends StatefulWidget {
  final int logId;
  const DetailScreen({super.key, required this.logId});

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
    final logDetail = await BookLogDetailService.fetchLogDetail(widget.logId);
    print(
        'logDetail: id=${logDetail?.id}, title=${logDetail?.title}, content length=${logDetail?.content.length}');

    setState(() {
      title = logDetail!.title;
      contents = logDetail!.content;
      backgroundImage = logDetail!.background;
      isLoaded = true;
    });
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
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Column(
                        children: List.generate(repeatCount, (index) {
                          return (backgroundImage != null &&
                                  backgroundImage!.isNotEmpty)
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
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 10),
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
