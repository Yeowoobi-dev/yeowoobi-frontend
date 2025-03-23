import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.mainBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.only(left: 20), // 중앙 정렬 안 맞아서 조정
                    child: Image.asset(
                      'assets/image/fox.png',
                      width: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "여우비에 오신 것을\n환영해요 :)",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "서비스 이용을 위해 로그인 해주세요.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),

              //카카오 로그인 버튼
              GestureDetector(
                onTap: () {
                  print("카카오 로그인 클릭됨");
                  // 로그인 로직
                },
                child: Image.asset(
                  'assets/image/kakao_login_large_wide.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
