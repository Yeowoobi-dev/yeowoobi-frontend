class SnsPostListItem {
  final int id;
  final String bookTitle;
  final String logTitle;
  final String bookImage;
  final String author;
  final String createdAt;
  final int likesCount;
  final int commentsCount;
  final String review;
  final String userNickname;

  SnsPostListItem({
    required this.id,
    required this.bookTitle,
    required this.logTitle,
    required this.bookImage,
    required this.author,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    required this.review,
    required this.userNickname,
  });

  factory SnsPostListItem.fromJson(Map<String, dynamic> json) {
    return SnsPostListItem(
      id: json['id'],
      bookTitle: json['bookTitle'] ?? '',
      logTitle: json['logTitle'] ?? '',
      bookImage: json['bookImage'] ?? '',
      author: json['author'] ?? '',
      createdAt: json['createdAt'] ?? '',
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      review: json['review'] ?? '',
      userNickname: json['userNickname'] ?? '',
    );
  }
}