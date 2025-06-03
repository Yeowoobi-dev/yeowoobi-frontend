class SnsPost {
  final int id;
  final String createdAt;
  final String updatedAt;
  final int version;
  final String userId;
  final String logTitle;
  final List<dynamic> text;
  final String background;
  final String? review;
  final String? category;
  final String bookTitle;
  final String bookImage;
  final String author;
  final String? publisher;
  final String visibility;
  final int likesCount;
  final int commentsCount;

  SnsPost({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.userId,
    required this.logTitle,
    required this.text,
    required this.background,
    required this.review,
    required this.category,
    required this.bookTitle,
    required this.bookImage,
    required this.author,
    required this.publisher,
    required this.visibility,
    required this.likesCount,
    required this.commentsCount,
  });

  factory SnsPost.fromJson(Map<String, dynamic> json) {
    return SnsPost(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      version: json['version'],
      userId: json['userId'],
      logTitle: json['logTitle'],
      text: json['text'] ?? [],
      background: json['background'] ?? '',
      review: json['review'],
      category: json['category'],
      bookTitle: json['bookTitle'] ?? '',
      bookImage: json['bookImage'] ?? '',
      author: json['author'] ?? '',
      publisher: json['publisher'],
      visibility: json['visibility'] ?? '',
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'version': version,
      'userId': userId,
      'logTitle': logTitle,
      'text': text,
      'background': background,
      'review': review,
      'category': category,
      'bookTitle': bookTitle,
      'bookImage': bookImage,
      'author': author,
      'publisher': publisher,
      'visibility': visibility,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
    };
  }
}