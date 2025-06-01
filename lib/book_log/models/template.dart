class Template {
  final String id;
  final String userId;
  final String name;
  final List<Map<String, dynamic>> contents;
  Template({
    required this.id,
    required this.userId,
    required this.name,
    required this.contents,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      contents: (json['contents'] as List).map((e) {
        if (e is Map<String, dynamic>) {
          return e.containsKey('insert') ? e : {'insert': e.toString()};
        }
        return {'insert': e.toString()};
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'contents': contents,
    };
  }
}
