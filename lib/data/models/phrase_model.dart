
class Phrase {
  final int id;
  final Map<String, String> translatedText;
  final int category;

  const Phrase({
    required this.id,
    required this.translatedText,
    required this.category,
  });

  factory Phrase.fromJson(Map<String, dynamic> json) {
    final Map<String, String> texts = {};
    if (json['translated_text'] != null) {
      (json['translated_text'] as Map<String, dynamic>).forEach((key, value) {
        texts[key.toLowerCase()] = value?.toString() ?? '';
      });
    }

    return Phrase(
      id: json['id'] ?? 0,
      translatedText: texts,
      category: json['category'] ?? 0,
    );
  }

  String getTranslation(String language) {
    final key = language.toLowerCase();
    return translatedText[key] ?? '';
  }
}
