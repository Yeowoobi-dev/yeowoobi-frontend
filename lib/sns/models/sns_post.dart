class SnsPost {
  final String bookTitle;
  final String title;
  final String uploader;
  final String time;
  final int likes;
  final int comments;
  final String feedImage;
  final String coverImage;
  final String review; // 추가

  SnsPost({
    required this.bookTitle,
    required this.title,
    required this.uploader,
    required this.time,
    required this.likes,
    required this.comments,
    required this.feedImage,
    required this.coverImage,
    required this.review, // 추가
  });

  factory SnsPost.fromJson(Map<String, dynamic> json) {
    return SnsPost(
      bookTitle: json['bookTitle'] ?? '',
      title: json['title'] ?? '',
      uploader: json['uploader'] ?? '',
      time: json['time'] ?? '',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      feedImage: json['feedImage'] ?? '',
      coverImage: json['coverImage'] ?? '',
      review: json['review'] ?? '', // 추가
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookTitle': bookTitle,
      'title': title,
      'uploader': uploader,
      'time': time,
      'likes': likes,
      'comments': comments,
      'feedImage': feedImage,
      'coverImage': coverImage,
      'review': review, // 추가
    };
  }
}