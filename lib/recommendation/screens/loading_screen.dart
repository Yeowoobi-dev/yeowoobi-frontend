import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yeowoobi_frontend/recommendation/screens/result_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _fetchResult();
  }

  Future<void> _fetchResult() async {
    await Future.delayed(Duration(seconds: 3));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultScreen(),
      ),
    );

    // 백앤드 연결 파트
    // final response =
    //     await http.get(Uri.parse());
    //
    // if (response.statusCode == 200) {
    //   final resultData = jsonDecode(response.body);
    //   if (!mounted) return;
    //   Navigator.of(context).pushReplacementNamed(
    //     '/result_screen',
    //     arguments: resultData,
    //   );
    // } else {
    // }
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 32.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
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
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.brown,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Image.asset('assets/gif/q3.gif', height: 480),
            const SizedBox(height: 60),
            SizedBox(
              width: 200,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
