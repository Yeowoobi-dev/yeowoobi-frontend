import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/recommendation/services/questions_service.dart';
import '../models/recommendedBook.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class ResultScreen extends StatefulWidget {
  final List<String> answers;
  final RecommendedBook recommendedBook;
  const ResultScreen({required this.answers, required this.recommendedBook});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱바
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: CustomTheme.lightBackgroundColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                        horizontal: 20, vertical: 12),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.recommendedBook.image,
                            width: 100,
                            height: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 160,
                                color: Colors.grey[300],
                                child: Icon(Icons.broken_image,
                                    color: Colors.grey),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.recommendedBook.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.recommendedBook.author,
                          style: const TextStyle(fontSize: 16),
                        ),
                        /*Text(
                          widget.recommendedBook.publisher,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey),
                        ),*/
                        const SizedBox(height: 8),
                        /*const Row( // 별점 및 출판사 숨기기
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star,
                                size: 18, color: Colors.orange),
                            SizedBox(width: 4),
                          ],
                        ),*/
                        Text(
                          widget.recommendedBook.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black54, height: 1.4),
                        ),
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
                          child:
                              Image.asset('assets/image/mini.png', width: 36),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 48.0, top: 8.0),
                          child: Text(
                            widget.recommendedBook.ment,
                            style: const TextStyle(height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              final newBook =
                                  await QuestionsService.fetchRecommendedBooks(
                                      widget.answers);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ResultScreen(
                                    answers: widget.answers,
                                    recommendedBook: newBook,
                                  ),
                                ),
                              );
                            } catch (e) {
                              print("추천 도서 재호출 실패: $e");
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomTheme.lightPrimaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 42, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "다른 책 추천받기",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
