// lib/recommendation/models/recommendedBook.dart

class RecommendedBook {
  final String title;
  final String author;
  final String image;
  final String publisher;
  final String description;
  final String ment;

  RecommendedBook({
    required this.title,
    required this.author,
    required this.image,
    required this.publisher,
    required this.description,
    required this.ment,
  });

  factory RecommendedBook.fromJson(Map<String, dynamic> json) {
    return RecommendedBook(
      title: json['title'],
      author: json['author'],
      image: json['image'],
      publisher: json['publisher'],
      description: json['description'],
      ment: json['ment'],
    );
  }
}
