class Question {
  final String question;
  final List<String> options;

  Question({
    required this.question,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      options: List<String>.from(json['options']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
    };
  }
}
