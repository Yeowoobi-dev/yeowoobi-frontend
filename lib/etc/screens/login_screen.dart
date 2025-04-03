import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:yeowoobi_frontend/etc/screens/home_screen.dart';

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
  final TextEditingController _introductionController = TextEditingController();

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
    '여우비',
  ];

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_validate);
  }

  // 닉네임 유효성 검사
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
    _introductionController.dispose();
    super.dispose();
  }

  final FocusNode _nicknameFocusNode = FocusNode();
  final FocusNode _introductionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: _showIntroductionForm
              ? _buildIntroductionForm(cs, theme)
              : _showKeywordForm
                  ? _buildKeywordSelectionForm(cs, theme)
                  : _showNicknameForm
                      ? _buildNicknameForm(cs, theme)
                      : _buildLoginView(cs, theme),
        ),
      ),
    );
  }

  // [1] 로그인 화면
  Widget _buildLoginView(ColorScheme cs, ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const SizedBox(height: 80),
            Image.asset('assets/image/fox.png',
                width: 180, fit: BoxFit.contain),
            const SizedBox(height: 40),
            Text("여우비에 오신 것을\n환영해요 :)",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text("서비스 이용을 위해 로그인 해주세요.",
                textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
          ],
        ),
        GestureDetector(
          onTap: () => setState(() => _showNicknameForm = true),
          child: Image.asset('assets/image/kakao_login_large_wide.png',
              width: double.infinity, fit: BoxFit.contain),
        ),
      ],
    );
  }

  // [2] 닉네임 설정 화면
  Widget _buildNicknameForm(ColorScheme cs, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(-8, 0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: cs.primary),
            onPressed: () => setState(() => _showNicknameForm = false),
          ),
        ),
        Text("닉네임을\n설정해주세요.", style: theme.textTheme.headlineMedium),
        const SizedBox(height: 16),
        Text("여우비가 당신을 어떻게 부르면 될까요?", style: theme.textTheme.bodyMedium),
        const SizedBox(height: 32),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nicknameController,
              maxLength: 10,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: '닉네임을 입력하세요',
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                border: InputBorder.none,
                counterText: '',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              ),
            ),
            Container(height: 1.5, color: CustomTheme.neutral200),
            const SizedBox(height: 10),
            Text('(${_nicknameController.text.length}/10)',
                style: theme.textTheme.bodySmall),
          ],
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isValid
                ? () => setState(() {
                      _showNicknameForm = false;
                      _showKeywordForm = true;
                    })
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isValid ? cs.primary : Colors.white,
              foregroundColor: _isValid ? Colors.white : cs.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text("다음",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // [3] 키워드 선택 화면
  Widget _buildKeywordSelectionForm(ColorScheme cs, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(-8, 0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: cs.primary),
            onPressed: () => setState(() {
              _showKeywordForm = false;
              _showNicknameForm = true;
            }),
          ),
        ),
        Text("${_nicknameController.text}님의 독서취향을\n알고싶어요!",
            style: theme.textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text("관심있는 키워드를 선택하시면\n여우비가 ${_nicknameController.text}님의 책장을 꾸며드릴게요.",
            style: theme.textTheme.bodyMedium),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _keywords.map((keyword) {
            final selected = _selectedKeywords.contains(keyword);
            return GestureDetector(
              onTap: () => setState(() {
                selected
                    ? _selectedKeywords.remove(keyword)
                    : _selectedKeywords.add(keyword);
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? cs.tertiary : CustomTheme.neutral100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  keyword,
                  style: TextStyle(
                    color: selected ? Colors.white : cs.tertiary,
                    fontWeight: FontWeight.bold,
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
                ? () => setState(() {
                      _showKeywordForm = false;
                      _showIntroductionForm = true;
                    })
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedKeywords.isNotEmpty
                  ? cs.primary
                  : cs.secondary.withValues(alpha: (0.3 * 255)),
              foregroundColor:
                  _selectedKeywords.isNotEmpty ? Colors.white : cs.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text("다음",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // [4] 소개글 설정 화면
  Widget _buildIntroductionForm(ColorScheme cs, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(-8, 0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: cs.primary),
            onPressed: () => setState(() {
              _showIntroductionForm = false;
              _showKeywordForm = true;
            }),
          ),
        ),
        Text("${_nicknameController.text}님이 \n궁금해요!",
            style: theme.textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text("${_nicknameController.text}님을 소개해주세요.",
            style: theme.textTheme.bodyMedium),
        const SizedBox(height: 32),
        TextField(
          controller: _introductionController,
          maxLines: 5,
          maxLength: 100,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: '소개글을 입력하세요',
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            border: InputBorder.none,
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text("완료",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
