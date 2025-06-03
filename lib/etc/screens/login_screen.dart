import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
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
  final FocusNode _nicknameFocusNode = FocusNode();
  final FocusNode _introductionFocusNode = FocusNode();

  bool _isValid = false;
  final Set<String> _selectedKeywords = {};

  List<String> _keywords = [];

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_validate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadKeywords();
    });
  }

  Future<void> _loadKeywords() async {
    final String data = await DefaultAssetBundle.of(context)
        .loadString('assets/book_category.json');
    final List<dynamic> jsonResult = jsonDecode(data);
    setState(() {
      _keywords = jsonResult.map((e) => e['name'] as String).toList();
    });
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
    _introductionController.dispose();
    _nicknameFocusNode.dispose();
    _introductionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loginWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token;

      if (isInstalled) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      print('카카오 엑세스 토큰: ${token.accessToken}');
      await _sendTokenToServer(token.accessToken);
    } catch (e) {
      print('카카오 로그인 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카카오 로그인 실패: $e')),
      );
    }
  }

  Future<void> _sendTokenToServer(String accessToken) async {
    try {
      final url = Uri.parse('http://43.202.170.189:3002/auth/kakao/ios');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'accessToken': accessToken}),
      );
      print('👉 보낼 데이터: ${jsonEncode({
            'accessToken': accessToken,
          })}');

      if (response.statusCode == 200  || response.statusCode == 201) {
        print('서버 로그인 성공: ${response.body}');
        // 바로 닉네임 설정 화면으로 이동
        setState(() {
          _showNicknameForm = true;
        });
      } else {
        print('서버 로그인 실패: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('서버 로그인 실패: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('서버 로그인 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버 로그인 실패: $e')),
      );
    }
  }

  bool get _showFormAppBar =>
      _showNicknameForm || _showKeywordForm || _showIntroductionForm;

  void _handleBackNavigation() {
    setState(() {
      if (_showIntroductionForm) {
        _showIntroductionForm = false;
        _showKeywordForm = true;
      } else if (_showKeywordForm) {
        _showKeywordForm = false;
        _showNicknameForm = true;
      } else if (_showNicknameForm) {
        _showNicknameForm = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _showFormAppBar
          ? AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon:
                      Icon(Icons.arrow_back_ios, color: CustomTheme.neutral200),
                  onPressed: _handleBackNavigation,
                ),
              ),
            )
          : null,
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
          onTap: _loginWithKakao,
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
        Text("${_nicknameController.text}님의 독서취향을\n알고싶어요!",
            style: theme.textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text("관심있는 키워드를 선택하시면\n여우비가 ${_nicknameController.text}님의 책장을 꾸며드릴게요.",
            style: theme.textTheme.bodyMedium),
        const SizedBox(height: 24),
        Wrap(
          spacing: 6,
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
                  : cs.secondary.withOpacity(0.3),
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
            counterText: '',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: CustomTheme.neutral200),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: CustomTheme.neutral300, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            //contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
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
