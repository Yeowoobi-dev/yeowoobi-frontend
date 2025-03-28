import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/etc/screens/home_screen.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showNicknameForm = false;
  bool _showKeywordForm = false;
  bool _showIntroductionForm = false;

  final TextEditingController _nicknameController = TextEditingController();
  bool _isValid = false;
  Set<String> _selectedKeywords = {};

  final List<String> _keywords = [
    '정치/사회',
    '언론/미디어',
    '영업',
    '마케팅/홍보',
    '법률',
    '의료/복지',
    '문화/예술',
    '소설',
    'SF/판타지',
    '역사',
    'IT/과학',
    '자기 개발',
    '아웃도어/레저',
    '교육',
    '육아',
    '경제/금융',
    '스릴러/공포',
    '여우비'
  ];

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_validate);
  }

  void _validate() {
    final text = _nicknameController.text.trim();
    final isValidFormat = RegExp(r'^[가-힣a-zA-Z0-9]+$').hasMatch(text);
    setState(() {
      _isValid = text.length >= 2 && isValidFormat;
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.mainBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: _showIntroductionForm
              ? _buildIntroductionForm()
              : _showKeywordForm
                  ? _buildKeywordSelectionForm()
                  : _showNicknameForm
                      ? _buildNicknameForm()
                      : _buildLoginView(),
        ),
      ),
    );
  }

  /// [1] 카카오 로그인 첫 화면
  Widget _buildLoginView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const SizedBox(height: 80),
            Image.asset('assets/image/fox.png',
                width: 180, fit: BoxFit.contain),
            const SizedBox(height: 40),
            const Text(
              "여우비에 오신 것을\n환영해요 :)",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 12),
            const Text(
              "서비스 이용을 위해 로그인 해주세요.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _showNicknameForm = true;
            });
          },
          child: Image.asset(
            'assets/image/kakao_login_large_wide.png',
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  /// [2] 닉네임 입력 폼
  Widget _buildNicknameForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(-8, 0), // 왼쪽으로 8px 이동
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              setState(() {
                _showKeywordForm = false;
                _showNicknameForm = true;
              });
            },
          ),
        ),
        // const SizedBox(height: 16),
        const Text(
          "닉네임을\n설정해주세요.",
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 16),
        const Text(
          "여우비가 당신을 어떻게 부르면 될까요?",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 32),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nicknameController,
              maxLength: 10,
              style: const TextStyle(fontSize: 15, color: Colors.black),
              decoration: InputDecoration(
                hintText: '닉네임을 입력하세요',
                filled: true,
                fillColor: CustomTheme.mainBackgroundColor,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                counterText: '',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              ),
            ),
            Container(
              height: 1.5,
              width: double.infinity,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(
              '(${_nicknameController.text.length}/10)',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isValid
                ? () {
                    setState(() {
                      _showNicknameForm = false;
                      _showKeywordForm = true;
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _isValid ? CustomTheme.lightPrimaryColor : Colors.grey[100],
              foregroundColor: _isValid ? Colors.white : Colors.black38,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text("입력 완료", style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 20), // 하단 간격
      ],
    );
  }

  /// [3] 키워드 선택 화면
  Widget _buildKeywordSelectionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(-8, 0), // 왼쪽으로 8px 이동
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              setState(() {
                _showKeywordForm = false;
                _showNicknameForm = true;
              });
            },
          ),
        ),
        // const SizedBox(height: 16),
        Text(
          "${_nicknameController.text}님의 독서취향을\n알고싶어요!",
          style: const TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 12),
        Text(
          "관심있는 키워드를 선택하시면\n여우비가 ${_nicknameController.text}님의 책장을 꾸며드릴게요.",
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _keywords.map((keyword) {
            final isSelected = _selectedKeywords.contains(keyword);
            return GestureDetector(
              onTap: () {
                setState(() {
                  isSelected
                      ? _selectedKeywords.remove(keyword)
                      : _selectedKeywords.add(keyword);
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF9C5A3C)
                      : const Color(0xFFF1ECE8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  keyword,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _selectedKeywords.isNotEmpty
                ? () {
                    setState(() {
                      _showKeywordForm = false;
                      _showIntroductionForm = true;
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedKeywords.isNotEmpty
                  ? CustomTheme.lightPrimaryColor
                  : Colors.grey[200],
              foregroundColor:
                  _selectedKeywords.isNotEmpty ? Colors.white : Colors.black38,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text("선택 완료", style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 20), // 하단 간격
      ],
    );
  }

  /// [4] 소개글 입력 화면
  Widget _buildIntroductionForm() {
    final TextEditingController _introductionController =
        TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(-8, 0), // 왼쪽으로 8px 이동
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              setState(() {
                _showIntroductionForm = false;
                _showKeywordForm = true;
              });
            },
          ),
        ),
        Text(
          "${_nicknameController.text}님이 \n궁금해요!",
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "${_nicknameController.text}님을 소개해주세요.",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _introductionController,
          maxLines: 5,
          maxLength: 100,
          style: const TextStyle(fontSize: 15, color: Colors.black),
          decoration: InputDecoration(
            hintText: '소개글을 입력하세요',
            filled: true,
            fillColor: CustomTheme.mainBackgroundColor,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            counterText: '',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              print("입력된 소개글: ${_introductionController.text}");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomTheme.lightPrimaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text("입력 완료", style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
