import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:yeowoobi_frontend/etc/screens/profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                const Expanded(
                  child: Text('박휘윤', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

            // 리스트 항목
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