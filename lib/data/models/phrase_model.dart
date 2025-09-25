class Phrase {
  final int id;
  final Map<String, dynamic> translatedText;
  final int category;

  Phrase({
    required this.id,
    required this.translatedText,
    required this.category,
  });

  factory Phrase.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> texts = {};
    if (json['translated_text'] != null) {
      (json['translated_text'] as Map<String, dynamic>).forEach((key, value) {
        texts[key.toLowerCase()] = value;
      });
    }

    return Phrase(
      id: json['id'],
      translatedText: texts,
      category: json['category'] ?? 0,
    );
  }
}

class Category {
  final int id;
  final String name;
  final String icon;

  Category({required this.id, required this.name, required this.icon});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      icon: json['icon'] ?? "",
    );
  }
}
