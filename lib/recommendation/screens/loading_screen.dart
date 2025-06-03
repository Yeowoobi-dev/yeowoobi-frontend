import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/recommendation/screens/result_screen.dart';
import 'package:yeowoobi_frontend/recommendation/services/questions_service.dart';
import 'package:yeowoobi_frontend/recommendation/models/recommendedBook.dart';

class LoadingScreen extends StatefulWidget {
  final List<String> answers;

  LoadingScreen(this.answers);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Future<RecommendedBook> _bookFuture;

  @override
  void initState() {
    super.initState();
    // API 요청
    _bookFuture = QuestionsService.fetchRecommendedBooks(widget.answers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<RecommendedBook>(
        future: _bookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 32.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 30.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE3C4), // 연한 주황색 배경
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      "너에게 딱 맞는 책을 추천해줄게!\n잠시만 기다려줘",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.brown,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.asset('assets/image/yeowoong1.png', height: 460),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            // 데이터 로딩 성공 시
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ResultScreen(
                    recommendedBook: snapshot.data!,
                    answers: widget.answers,
                  ),
                ),
              );
            });
            return const SizedBox.shrink();
          } else {
            // 데이터 로딩 실패 시
            return Center(child: Text("책 추천에 실패했어요. 다시 시도해주세요."));
          }
        },
      ),
    );
  }
}
