import 'package:yeowoobi_frontend/recommendation/screens/question_screen.dart';
import 'package:flutter/material.dart';

class BookRecommendScreen extends StatelessWidget {
  const BookRecommendScreen({super.key});

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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    "안녕! 난 여웅이야\n너에게 딱 맞는 책을 추천해줄게",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Image.asset('assets/image/yeowoong1.png', height: 460),
                const SizedBox(height: 60),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => QuestionScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      animationDuration: Duration.zero, // Disable animation
                    ),
                    child: const Text(
                      "시작하기",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
