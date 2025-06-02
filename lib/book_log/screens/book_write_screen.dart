import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:yeowoobi_frontend/book_log/services/book_service.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:yeowoobi_frontend/book_log/screens/detail_screen.dart';

class BookWriteScreen extends StatefulWidget {
  final List<dynamic>? initialContents;
  final String bookTitle;
  final String bookImage;
  final String author;
  final String category;
  const BookWriteScreen({
    super.key,
    required this.initialContents,
    required this.bookTitle,
    required this.bookImage,
    required this.author,
    required this.category,
  });

  @override
  _BookWriteScreenState createState() => _BookWriteScreenState();
}

class _BookWriteScreenState extends State<BookWriteScreen> {
  late final QuillController _controller;
  final FocusNode _editorFocusNode = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  final ScrollController _editorScrollController = ScrollController();
  double? _currentFontSize;
  Attribute<dynamic> _currentAlignment = Attribute.leftAlignment;
  IconData _currentAlignmentIcon = Icons.format_align_left;
  String? _selectedBackground;
  List<String> _backgroundOptions = [];

  @override
  void initState() {
    super.initState();
    // 넘어온 데이터 출력
    print('BookWriteScreen loaded with:');
    print('Title: ${widget.bookTitle}');
    print('Author: ${widget.author}');
    print('Image URL: ${widget.bookImage}');
    print('Category: ${widget.category}');
    if (widget.initialContents != null &&
        widget.initialContents!.isNotEmpty &&
        Delta.fromJson(widget.initialContents!).isNotEmpty) {
      final delta = Delta.fromJson(widget.initialContents!);
      _controller = QuillController(
        document: Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _controller = QuillController.basic();
    }
    _titleController.addListener(() {
      setState(() {});
    });
    _loadBackgroundOptions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_editorFocusNode);
      _controller.formatSelection(Attribute.clone(Attribute.bold, null));
      _controller.formatSelection(Attribute.clone(Attribute.italic, null));
      _controller.formatSelection(Attribute.clone(Attribute.underline, null));
      _controller
          .formatSelection(Attribute.clone(Attribute.strikeThrough, null));
      _controller.formatSelection(Attribute.clone(Attribute.blockQuote, null));
    });
  }

  Future<void> _loadBackgroundOptions() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final backgrounds = manifestMap.keys
        .where((key) =>
            key.startsWith('assets/background/') && p.extension(key) == '.png')
        .toList();
    setState(() {
      _backgroundOptions = ['없음', ...backgrounds];
      _selectedBackground = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorFocusNode.dispose();
    _titleController.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.neutral100,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // 앱바 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      // onPressed: () => Navigator.pop(context).pop(),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                '임시 저장하시겠습니까?',
                                style: TextStyle(fontSize: 18),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop(); // 저장 안 하고 나가기
                                  },
                                  child: const Text('작성취소'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // 임시 저장 로직 추가 필요
                                    Navigator.of(context).pop(); // 닫기
                                    Navigator.of(context).popUntil(
                                        (route) => route.isFirst); // 홈화면으로 이동
                                  },
                                  child: const Text('임시저장'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    // 키패드 버튼
                    icon: const Icon(Icons.keyboard),
                    onPressed: () {
                      if (FocusScope.of(context).hasFocus) {
                        FocusScope.of(context).unfocus();
                      } else {
                        FocusScope.of(context).requestFocus(_editorFocusNode);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final renderBox = _editorFocusNode.context
                              ?.findRenderObject() as RenderBox?;
                          if (renderBox != null && renderBox.attached) {
                            Scrollable.ensureVisible(
                              _editorFocusNode.context!,
                              alignment: 1.0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        });
                      }
                    },
                  ),
                  IconButton(
                    // 저장 버튼
                    icon: const Icon(Icons.save),
                    onPressed: () async {
                      final TextEditingController _reviewController =
                          TextEditingController();
                      final result = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('한줄 리뷰'),
                            content: SizedBox(
                              width: 300, // fixed width
                              child: TextField(
                                controller: _reviewController,
                                maxLength: 50,
                                decoration: const InputDecoration(
                                  hintText: '최대 50자까지 입력할 수 있어요',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop('public'),
                                child: const Text('공개'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop('private'),
                                child: const Text('비공개'),
                              ),
                            ],
                          );
                        },
                      );

                      if (result != null) {
                        final title = _titleController.text.trim();
                        final deltaJson =
                            _controller.document.toDelta().toJson();

                        print('Delta: $deltaJson'); // 디버깅용 로그

                        final logData = Map<String, dynamic>.from({
                          //'userId': "c1f93145-4ec4-404a-9f6c-991803095d64",
                          'title': title,
                          'text': deltaJson,
                          'background': _selectedBackground ?? '',
                          'visibility': result,
                          'review': _reviewController.text.trim(),
                          'bookTitle': widget.bookTitle,
                          'bookImage': widget.bookImage,
                          'author': widget.author,
                          'category': widget.category,
                          'createdAt': DateTime.now().toIso8601String(),
                          'updatedAt': DateTime.now().toIso8601String(),
                        });
/*
                        // 디버깅 로그 from book_write_screen.dart
                        print('Saving log data:');
                        print('Log Title: $title');
                        print('Review: ${_reviewController.text.trim()}');
                        print('Background: $_selectedBackground');
                        print('Author: ${widget.author}');
                        print('Category: ${widget.category}');
*/
                        // 서버로 저장 (POST)
                        final success =
                            await NewBookLogSPost.postBookLog(logData);
                        if (success) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const DetailScreen(),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              //앱바와 에디터 사이의 구분선
              thickness: 0.5,
              height: 1,
              color: CustomTheme.neutral200,
            ),
            // 제목 입력 및 에디터 영역
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final backgroundHeight = screenWidth * 1.414;
                  final baseHeight =
                      _controller.document.toPlainText().split('\n').length *
                          28.0;
                  final estimatedContentHeight = baseHeight <
                          constraints.maxHeight
                      ? constraints.maxHeight +
                          MediaQuery.of(context).viewInsets.bottom
                      : baseHeight + MediaQuery.of(context).viewInsets.bottom;
                  final repeatCount =
                      (estimatedContentHeight / backgroundHeight).ceil();

                  return SingleChildScrollView(
                    controller: _editorScrollController,
                    child: Stack(
                      children: [
                        // Background column
                        Column(
                          children: List.generate(repeatCount, (index) {
                            return _selectedBackground != null
                                ? Image.asset(
                                    _selectedBackground!,
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
                              child: TextField(
                                controller: _titleController,
                                maxLength: 40, // 입력 최대 길이
                                buildCounter: (_, // 카운터 숨기기
                                        {required currentLength,
                                        required isFocused,
                                        maxLength}) =>
                                    null,
                                textAlign: TextAlign.start,
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
                            Divider(
                              // 제목과 에디터 사이의 구분선
                              thickness: 0.5,
                              color: CustomTheme.neutral200,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: QuillEditor(
                                focusNode: _editorFocusNode,
                                scrollController: _editorScrollController,
                                controller: _controller,
                                config: QuillEditorConfig(
                                  padding: const EdgeInsets.all(18),
                                  autoFocus: true,
                                  expands: false,
                                  scrollable: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // 툴바 영역
            const Divider(
              //에디터와 툴바 사이의 구분선
              thickness: 0.5,
              height: 1,
              color: CustomTheme.neutral200,
            ),
            Container(
              height: 40,
              color: CustomTheme.neutral100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    QuillToolbarHistoryButton(
                      // 되돌리기
                      isUndo: true,
                      controller: _controller,
                    ),
                    /*QuillToolbarHistoryButton(
                      // 되돌리기 취소
                      isUndo: false,
                      controller: _controller,
                    ),*/
                    QuillToolbarToggleStyleButton(
                      // 볼드체
                      controller: _controller,
                      attribute: Attribute.bold,
                    ),
                    QuillToolbarToggleStyleButton(
                      // 이탤릭체
                      controller: _controller,
                      attribute: Attribute.italic,
                    ),
                    QuillToolbarToggleStyleButton(
                      // 밑줄
                      controller: _controller,
                      attribute: Attribute.underline,
                    ),
                    QuillToolbarToggleStyleButton(
                      // 취소선
                      controller: _controller,
                      attribute: Attribute.strikeThrough,
                    ),
                    QuillToolbarToggleStyleButton(
                      // 인용구
                      controller: _controller,
                      attribute: Attribute.blockQuote,
                    ),
                    IconButton(
                      // 정렬
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
                    // 글씨 색상
                    QuillToolbarColorButton(
                      controller: _controller,
                      isBackground: false,
                    ),
                    // 배경 선택
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          const Text("배경"),
                          const SizedBox(width: 4),
                          DropdownButton<String>(
                            value: _selectedBackground ?? '',
                            underline: SizedBox.shrink(),
                            items: _backgroundOptions.map((path) {
                              return DropdownMenuItem(
                                value: path == '없음' ? '' : path,
                                child: path == '없음'
                                    ? Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color:
                                              CustomTheme.lightBackgroundColor,
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      )
                                    : Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(path),
                                            fit: BoxFit.cover,
                                          ),
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBackground =
                                    value == '' ? null : value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    QuillToolbarSelectHeaderStyleDropdownButton(
                      // 헤더 스타일
                      controller: _controller,
                    ),
                    // 폰트 크기
                    Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: DropdownButton<double>(
                        isDense: true,
                        underline: SizedBox.shrink(),
                        hint: const Text('16'),
                        value: _currentFontSize,
                        items: [12, 14, 16, 18, 20, 24, 28].map((size) {
                          return DropdownMenuItem(
                            value: size.toDouble(),
                            child: Text(
                              '$size',
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (size) {
                          if (size != null) {
                            setState(() {
                              _currentFontSize = size;
                              _controller.formatSelection(
                                Attribute.fromKeyValue('size', size.toString()),
                              );
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
      ),
    );
  }
}

void navigateToBookWriteScreen(BuildContext context, Map<String, dynamic> tpl) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BookWriteScreen(
        initialContents: (tpl['contents'] as List).map((e) {
          if (e is Map<String, dynamic> && e.containsKey('insert')) {
            final insert = e['insert'];
            final attrs = Map<String, dynamic>.from(e['attributes'] ?? {});
            if (insert == '\n') {
              // 줄바꿈에 붙은 인라인 스타일 제거
              attrs.removeWhere((key, value) =>
                  key == 'bold' ||
                  key == 'italic' ||
                  key == 'underline' ||
                  key == 'strike' ||
                  key == 'color' ||
                  key == 'background');
            }
            return {
              'insert': insert,
              if (attrs.isNotEmpty) 'attributes': attrs,
            };
          }
          return {'insert': e.toString()};
        }).toList(),
        bookTitle: tpl['bookTitle'],
        bookImage: tpl['bookImage'],
        author: tpl['author'],
        category: tpl['category'],
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.ease));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}
