class SnsPostDetail {
  final int id;
  final String logTitle;
  final List<dynamic> text; // 나중에 필요하면 더 구조화 가능
  final String? review;
  final String bookTitle;
  final String bookImage;
  final String author;
  final int likesCount;
  final int commentsCount;
  final String createdAt;
  final String userNickname;

  SnsPostDetail({
    required this.id,
    required this.logTitle,
    required this.text,
    required this.review,
    required this.bookTitle,
    required this.bookImage,
    required this.author,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    required this.userNickname,
  });

  factory SnsPostDetail.fromJson(Map<String, dynamic> json) {
    return SnsPostDetail(
      id: json['id'],
      logTitle: json['logTitle'] ?? '',
      text: json['text'] ?? [],
      review: json['review'],
      bookTitle: json['bookTitle'] ?? '',
      bookImage: json['bookImage'] ?? '',
      author: json['author'] ?? '',
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      userNickname: json['userNickname'] ?? '',
    );
  }
}