import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        title: const Text('프로필', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 프로필 정보
            Row(
              children: [
                const CircleAvatar(radius: 35, backgroundColor: CustomTheme.neutral300),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('박휘윤', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text(
                      '안녕하세요! 판타지 소설을 좋아하는 대학생입니다.',
                      style: TextStyle(fontSize: 14, color: CustomTheme.neutral300),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 키워드 태그
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                '#어쩌고', '#저쩌고', '#이게맞나요'
              ].map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: CustomTheme.neutral100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              )).toList(),
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1, color: CustomTheme.neutral100),
            const SizedBox(height: 16),

            // 나의 독서록 모음
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('나의 독서록 모음', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: '최신순',
                  items: ['최신순', '좋아요순'].map((val) => DropdownMenuItem(
                    value: val,
                    child: Text(val),
                  )).toList(),
                  onChanged: (val) {},
                  underline: const SizedBox.shrink(),
                )
              ],
            ),
            const SizedBox(height: 12),

            // 더미 독서록 카드 리스트
            Column(
              children: List.generate(3, (index) => _dummyBookCard()),
            )
          ],
        ),
      ),
    );
  }

  Widget _dummyBookCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 140,
                  color: CustomTheme.neutral100,
                  margin: const EdgeInsets.only(bottom: 8),
                ),
                Container(
                  height: 14,
                  width: 100,
                  color: CustomTheme.neutral100,
                  margin: const EdgeInsets.only(bottom: 8),
                ),
                Container(
                  height: 14,
                  width: 60,
                  color: CustomTheme.neutral100,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 56,
            height: 70,
            color: CustomTheme.neutral100,
          )
        ],
      ),
    );
  }
}
