import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/etc/screens/home_screen.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';
import 'package:yeowoobi_frontend/book_log/models/logData.dart';
import 'package:yeowoobi_frontend/book_log/services/book_service.dart';
import 'package:yeowoobi_frontend/book_log/screens/book_select_screen.dart';
import 'package:yeowoobi_frontend/recommendation/screens/book_recommend_screen.dart';

class BookLogScreen extends StatefulWidget {
  const BookLogScreen({super.key});

  @override
  State<BookLogScreen> createState() => _BookLogScreenState();
}

class _BookLogScreenState extends State<BookLogScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSort = '최신순';
  bool isGridView = false;

  List<LogData>? _filteredLogs;
  List<LogData> _allLogs = [];

  Future<List<LogData>>? _logFuture;

  @override
  void initState() {
    super.initState();
    _logFuture = MyBookLogService.fetchMyLogs().then((logs) {
      _allLogs = logs;
      return logs;
    });

    _searchController.addListener(() {
      setState(() {
        _filteredLogs = _filterLogs(_allLogs, _searchController.text);
      });
    });
  }

  Future<void> _refreshBooks() async {
    final logs = await MyBookLogService.fetchMyLogs();
    setState(() {
      _allLogs = logs;
      _logFuture = Future.value(logs);
      _filteredLogs = _filterLogs(logs, _searchController.text);
    });
  }

  List<LogData> _filterLogs(List<LogData> logs, String query) {
    final lowerQuery = query.toLowerCase();
    return logs.where((log) {
      return log.bookTitle.toLowerCase().contains(lowerQuery) ||
          log.author.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. AppBar 영역
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                    child:
                        Image.asset('assets/image/logo_orange.png', height: 36),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.book, color: Colors.black),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BookRecommendScreen()),
                          );
                        },
                      ),
                      IconButton(
                        icon: const ImageIcon(
                            AssetImage('assets/icons/user.png'),
                            color: Colors.black),
                        onPressed: () {
                          // TODO: 마이 프로필로 이동
                        },
                      ),
                    ],
                  ),
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

            // 3. 정렬 및 보기 방식 선택
            FutureBuilder<List<LogData>>(
              future: _logFuture ?? Future.value([]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('데이터 로딩 실패'));
                } else
                  (!snapshot.hasData || snapshot.data!.isEmpty);
                final logs = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('나의 책 ${_filteredLogs?.length ?? logs.length}권',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CustomTheme.neutral400,
                          )),
                      Row(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: CustomTheme.neutral100,
                            ),
                            child: DropdownButton<String>(
                              value: _selectedSort,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedSort = newValue;
                                  });
                                }
                              },
                              underline: SizedBox.shrink(),
                              items: [
                                '최신순',
                                '별점순',
                                '가나다순'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          IconButton(
                            icon: ImageIcon(
                              AssetImage(
                                isGridView
                                    ? 'assets/icons/vertical.png'
                                    : 'assets/icons/gallery.png',
                              ),
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isGridView = !isGridView;
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),

            // 4. 독서록 리스트 or 그리드
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: RefreshIndicator(
                  onRefresh: _refreshBooks,
                  child: FutureBuilder<List<LogData>>(
                    future: _logFuture ?? Future.value([]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('데이터 로딩 실패'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('아직 독서록이 없어요!',
                                style: TextStyle(fontSize: 18)));
                      }
                      final logs = snapshot.data!;
                      final logsToShow = _filteredLogs ?? logs;
                      return isGridView
                          ? _buildGridView(logsToShow)
                          : _buildListView(logsToShow);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // 5. 하단 floating 버튼
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const BookSelectScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  final tween =
                      Tween(begin: const Offset(0, 1), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: ImageIcon(AssetImage('assets/icons/write.png'),
                  color: Colors.white),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  // 리스트 뷰
  Widget _buildListView(List<LogData> logs) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: logs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final log = logs[index];
        return Container(
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
              Image.network(log.bookImage,
                  width: 50, height: 70, fit: BoxFit.cover), // 리스트에서 이미지 크기 고정
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(log.bookTitle,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(log.author, style: TextStyle(color: Colors.grey[600]))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // 그리드 뷰
  Widget _buildGridView(List<LogData> logs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: logs.length,
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, index) {
          final log = logs[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(log.bookImage, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.bookTitle,
                        maxLines: 2, // 제목 최대 2줄
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 1.2, // 줄 간격 설정 (기본값보다 작게)
                        ),
                      ),
                      Text(
                        log.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
