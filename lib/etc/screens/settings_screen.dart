import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:yeowoobi_frontend/etc/screens/profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String nickname = '익명'; // 기본값은 익명
  final String _token = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjA3NjY1MTE4LTcxN2EtNGVjZC05MDZmLTllYWQyYTIyYzkzYiIsImlhdCI6MTc0ODc1NjAzMywiZXhwIjoxNzUxMzQ4MDMzfQ.X7RpYpkDoii2ucukfeW99k3Xu2ddGvRnEjHw4jgu3hA'; // ✅ 네 토큰 하드코딩 or 불러오기

  @override
  void initState() {
    super.initState();
    _fetchNickname(); // 닉네임 가져오기
  }

  Future<void> _fetchNickname() async {
    try {
      final response = await http.get(
        Uri.parse('http://43.202.170.189:3000/users/me'), // ✅ 사용자 정보 가져오는 API
        headers: {
          'Authorization': _token,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          nickname = data['nickname'] ?? '익명'; // 닉네임 없으면 익명
        });
      } else {
        debugPrint('닉네임 불러오기 실패: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('닉네임 불러오기 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: CustomTheme.backgroundColor(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('설정', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // 프로필 영역
            Row(
              children: [
                const CircleAvatar(radius: 30, backgroundColor: CustomTheme.neutral300),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    nickname, // ✅ 여기 닉네임 표시
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    elevation: 0,
                  ),
                  child: const Text('프로필 접근'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _settingLink('이메일 수정'),
                _divider(),
                _settingLink('비밀번호 재설정'),
                _divider(),
                _settingLink('회원탈퇴'),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1, color: CustomTheme.neutral100),
            const SizedBox(height: 20),
            _settingButton('푸시 알람 설정'),
            _settingButton('공지사항'),
            _settingButton('서비스 이용약관'),
            _settingButton('테마설정', bottomMargin: 0),
            const SizedBox(height: 16),
            const Divider(thickness: 1, color: CustomTheme.neutral100),
            const SizedBox(height: 16),
            _settingButton('문의하기'),
            _settingButton('로그아웃'),
          ],
        ),
      ),
    );
  }

  Widget _settingLink(String label) {
    return GestureDetector(
      onTap: () => print('$label 클릭'),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _divider() => const Text(
    '｜',
    style: TextStyle(
      color: Colors.black87,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget _settingButton(String label, {double bottomMargin = 12}) {
    return GestureDetector(
      onTap: () => print('$label 클릭'),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: bottomMargin),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: CustomTheme.neutral100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}