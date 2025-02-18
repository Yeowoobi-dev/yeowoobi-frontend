// 로그인 화면

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("로그인")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 로그인 처리 로직 (예: Firebase Auth)
            print("로그인 버튼 클릭");
          },
          child: Text("Google로 로그인"),
        ),
      ),
    );
  }
}
