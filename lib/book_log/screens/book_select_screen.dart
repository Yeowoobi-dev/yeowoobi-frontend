import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:yeowoobi_frontend/book_log/models/book.dart';
import 'package:yeowoobi_frontend/book_log/services/book_service.dart';
import 'package:yeowoobi_frontend/book_log/screens/book_write_screen.dart';
import 'package:yeowoobi_frontend/book_log/screens/book_template_screen.dart';

class BookSelectScreen extends StatefulWidget {
  const BookSelectScreen({super.key});

  @override
  State<BookSelectScreen> createState() => _BookSelectScreenState();
}

class _BookSelectScreenState extends State<BookSelectScreen> {
  double _rating = 0;
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
  final Set<String> _selectedKeywords = {};

  final TextEditingController _searchController = TextEditingController();

  List<Book>? _filteredBooks;
  List<Book> _allBooks = [];

  Book? _selectedBook;

  late Future<List<Book>> _bookFuture;

  List<Map<String, dynamic>> _templates = [];

  Future<void> _loadTemplateNames() async {
    final jsonString = await rootBundle.loadString('assets/template.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    setState(() {
      _templates = jsonList
          .where((item) =>
              item is Map<String, dynamic> &&
              item['contents'] is List &&
              (item['contents'] as List)
                  .every((e) => e is Map<String, dynamic>))
          .cast<Map<String, dynamic>>()
          .take(4)
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _bookFuture = NewBookService.fetchNewBooks().then((books) {
      _allBooks = books;
      return books;
    });

    _searchController.addListener(() {
      setState(() {
        _filteredBooks = _filterBooks(_allBooks, _searchController.text);
      });
    });
    _loadTemplateNames(); // 템플릿 이름 로딩
  }

  Future<void> _refreshBooks() async {
    final books = await NewBookService.fetchNewBooks();
    setState(() {
      _allBooks = books;
      _bookFuture = Future.value(books);
      _filteredBooks = _filterBooks(books, _searchController.text);
    });
  }

  List<Book> _filterBooks(List<Book> books, String query) {
    final lowerQuery = query.toLowerCase();
    return books.where((book) {
      return book.title.toLowerCase().contains(lowerQuery) ||
          book.author.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Widget _buildDetailView(Book book) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 상단 뒤로가기 버튼
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      _selectedBook = null;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),

              // 2. 책 정보 및 별점 선택
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.only(
                        top: 80, left: 20, right: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 50), // 이미지 높이만큼 공간 확보
                        Text(book.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(book.author,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                index < _rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                              ),
                              onPressed: () {
                                setState(() {
                                  _rating = index + 1.0;
                                });
                              },
                            );
                          }),
                        ),
                        Text("별점을 남겨주세요.",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        book.imageUrl,
                        width: 100,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('카테고리',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
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
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              contentPadding: const EdgeInsets.all(24),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset('assets/image/logo_orange.png',
                                      height: 36),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "독서록 템플릿을 골라주세요!",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(height: 12),
                                  ..._templates.map((tpl) => Container(
                                        width: double.infinity,
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            elevation: 1,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    BookWriteScreen(
                                                  initialContents: (tpl[
                                                              'contents']
                                                          as List<dynamic>)
                                                      .map((e) =>
                                                          (e as Map<String,
                                                                      dynamic>)[
                                                                  'key']
                                                              ?.toString() ??
                                                          '')
                                                      .toList(),
                                                ),
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  final tween = Tween(
                                                    begin: const Offset(0, 1),
                                                    end: Offset.zero,
                                                  ).chain(CurveTween(
                                                      curve: Curves.ease));
                                                  return SlideTransition(
                                                    position:
                                                        animation.drive(tween),
                                                    child: child,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Text(tpl['name']),
                                        ),
                                      )),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const TemplateSelectScreen()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                      child: const Text('템플릿 수정'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedKeywords.isNotEmpty
                        ? cs.primary
                        : cs.secondary.withOpacity(0.3),
                    foregroundColor: _selectedKeywords.isNotEmpty
                        ? Colors.white
                        : cs.secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text("작성 시작",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_selectedBook == null) ...[
              // 1. AppBar 영역
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/image/logo_orange.png', height: 36),
                    IconButton(
                      icon: const ImageIcon(AssetImage('assets/icons/user.png'),
                          color: Colors.black),
                      onPressed: () {
                        // TODO: 마이 프로필로 이동
                      },
                    )
                  ],
                ),
              ),

              // 2. 검색바
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '책 제목, 작가를 검색해보세요!',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: ImageIcon(
                        AssetImage('assets/icons/search.png'),
                        size: 14,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                    fillColor: CustomTheme.neutral100,
                    filled: true,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],

            // 3. 리스트로 책 출력
            Expanded(
              child: _selectedBook != null
                  ? _buildDetailView(_selectedBook!)
                  : FutureBuilder<List<Book>>(
                      future: _bookFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('데이터 로딩 실패'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text('표시할 책이 없습니다.'));
                        }

                        final booksToShow = _filteredBooks ?? snapshot.data!;
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: booksToShow.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final book = booksToShow[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedBook = book;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(2, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Image.network(book.imageUrl,
                                        width: 50,
                                        height: 70,
                                        fit: BoxFit.cover),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(book.title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(book.author,
                                              style: TextStyle(
                                                  color: Colors.grey[600])),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
