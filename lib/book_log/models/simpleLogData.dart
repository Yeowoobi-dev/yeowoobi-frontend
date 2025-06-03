// book_log/models/logDataForList.dart

class SimpleLogData {
  final int id;
  final String userId;
  final String bookTitle;
  final String bookImage;
  final String author;
  final DateTime createdAt;
  final DateTime updatedAt;

  SimpleLogData({
    required this.id,
    required this.userId,
    required this.bookTitle,
    required this.bookImage,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SimpleLogData.fromJson(Map<String, dynamic> json) {
    return SimpleLogData(
      id: json['id'],
      userId: json['userId'],
      bookTitle: json['bookTitle'],
      bookImage: json['bookImage'],
      author: json['author'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
