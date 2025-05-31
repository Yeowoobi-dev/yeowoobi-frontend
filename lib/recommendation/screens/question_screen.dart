import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yeowoobi_frontend/recommendation/screens/loading_screen.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _BookQuestionScreenState();
}

class _BookQuestionScreenState extends State<QuestionScreen> {
  List<dynamic> _questions = [];
  int _currentIndex = 0;
  List<String> _answers = [];
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    final String data = await rootBundle.loadString('assets/questions.json');
    setState(() {
      _questions = json.decode(data);
    });
  }

  void _selectAnswer(String answer, int index) {
    setState(() {
      _selectedIndex = index;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _answers.add(answer);
      });

      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedIndex = -1;
        });
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoadingScreen()),
        );
      }
    });
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 140,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                alignment: Alignment.center,
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
                  question['question'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 280,
                child: Image.asset(question['image']),
              ),
              const SizedBox(height: 24),
              ...List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: GestureDetector(
                    onTap: () =>
                        _selectAnswer(question['options'][index], index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      width: double.infinity,
                      height: 56,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: CustomTheme.neutral100,
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
