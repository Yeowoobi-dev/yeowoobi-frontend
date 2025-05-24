import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:yeowoobi_frontend/recommendation/screens/result_screen.dart';

class BookQuestionScreen extends StatefulWidget {
  const BookQuestionScreen({super.key});

  @override
  State<BookQuestionScreen> createState() => _BookQuestionScreenState();
}

class _BookQuestionScreenState extends State<BookQuestionScreen> {
  List<dynamic> _questions = [];
  int _currentIndex = 0;
  List<String> _answers = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final String data = await rootBundle.loadString('assets/questions.json');
    setState(() {
      _questions = json.decode(data);
    });
  }

  void _selectAnswer(String answer) {
    setState(() {
      _answers.add(answer);
    });

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: CustomTheme.backgroundColor(context),
      appBar: AppBar(
        backgroundColor: CustomTheme.backgroundColor(context),
        elevation: 0,
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (_currentIndex > 0) {
              setState(() {
                _currentIndex--;
                _answers.removeLast();
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                //질문
                margin: const EdgeInsets.only(bottom: 32.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
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
                child: Text(
                  question['question'], // 질문 텍스트
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown,
                  ),
                ),
              ),
              Image.asset('assets/image/q1.png', height: 300),
              SizedBox(height: 24),
              // 선택지 버튼
              ...List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: GestureDetector(
                    onTap: () => _selectAnswer(question['options'][index]),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFFDED8D2),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        question['options'][index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
