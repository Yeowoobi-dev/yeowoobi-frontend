import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class BookWriteScreen extends StatefulWidget {
  final List<String>? initialContents;
  const BookWriteScreen({super.key, required this.initialContents});

  @override
  _BookWriteScreenState createState() => _BookWriteScreenState();
}

class _BookWriteScreenState extends State<BookWriteScreen> {
  late final QuillController _controller;
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();
  final TextEditingController _titleController = TextEditingController();
  double? _currentFontSize;
  Attribute<dynamic> _currentAlignment = Attribute.leftAlignment;
  IconData _currentAlignmentIcon = Icons.format_align_left;

  @override
  void initState() {
    super.initState();
    if (widget.initialContents != null && widget.initialContents!.isNotEmpty) {
      final delta = Delta()
        ..insert(widget.initialContents!.join('\n\n'))
        ..insert('\n');
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
            // 앱바 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      // onPressed: () => Navigator.pop(context).pop(),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('임시 저장하시겠습니까?'),
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
                      }
                    },
                  ),
                  IconButton(
                    // 저장 버튼
                    icon: const Icon(Icons.save),
                    onPressed: () {
                      // 실제 저장 로직 추가 필요
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst); // 홈화면으로 이동
                    },
                  ),
                ],
              ),
            ),
            // 제목 입력 및 에디터 영역
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                          thickness: 0.5, color: CustomTheme.neutral200),
                    ),
                    QuillEditor(
                      focusNode: _editorFocusNode,
                      scrollController: _editorScrollController,
                      controller: _controller,
                      config: QuillEditorConfig(
                        padding: const EdgeInsets.all(18), // 좌우 여백
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 툴바 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(thickness: 0.5, color: CustomTheme.neutral200),
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
                    QuillToolbarHistoryButton(
                      // 되돌리기 취소
                      isUndo: false,
                      controller: _controller,
                    ),
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
                    /*QuillToolbarSelectHeaderStyleDropdownButton(
                      // 헤더 스타일
                      controller: _controller,
                    ),*/
                    /*QuillToolbarSelectAlignmentButton(
                      controller: _controller,
                    ),*/
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
                    QuillToolbarColorButton(
                      controller: _controller,
                      isBackground: false,
                    ),
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
        initialContents: (tpl['contents'] as List<dynamic>)
            .map((e) => (e as Map<String, dynamic>)['insert']?.toString() ?? '')
            .toList(),
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
