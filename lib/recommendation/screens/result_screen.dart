import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Book? _randomBook;

  @override
  void initState() {
    super.initState();
    _loadRandomBook();
  }

  Future<void> _loadRandomBook() async {
    final String response = await rootBundle.loadString('assets/dummy.json');
    final List<dynamic> data = json.decode(response);
    final random = Random();
    final randomBook = data[random.nextInt(data.length)];
    setState(() {
      _randomBook = Book.fromJson(randomBook);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_randomBook == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: CustomTheme.lightBackgroundColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 24),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  _randomBook!.imageUrl,
                                  width: 100,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                _randomBook!.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _randomBook!.author,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              /*const Row( // 별점 및 출판사 숨기기
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star,
                                      size: 18, color: Colors.orange),
                                  SizedBox(width: 4),
                                  Text("4.5 출판사 | 창비"),
                                ],
                              ),*/
                              const SizedBox(height: 16),
                              const Text(
                                "“억압된 일상에서 벗어나려는 여자의 극단적 선택으로\n인간 내면의 욕망과 폭력을 날카롭게 그려낸 소설.”",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black54, height: 1.4),
                              ),
                              const SizedBox(height: 16)
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          margin: const EdgeInsets.only(bottom: 32.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE3C4),
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          // 추천 이유
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10,
                                left: 0,
                                child: Image.asset('assets/image/mini.png',
                                    width: 36),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 48.0, top: 8.0),
                                child: Text(
                                  "내가 이 책을 추천한 이유는, 이 책이 억압된 일상 속에서 벗어나려는 한 여성의 심리를 섬세하게 그려낸 내용을 담고 있고, 불편할 만큼 강렬한 분위기와 상징적인 서사가 인상적인 특징이 있어서 네가 좋아할 것 같기 때문이야!",
                                  style: const TextStyle(height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Removed: const SizedBox(height: 12),
                        // Removed: ElevatedButton(...)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _loadRandomBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomTheme.lightPrimaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "다른 책 추천받기",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
