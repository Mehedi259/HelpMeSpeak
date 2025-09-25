// lib/data/models/phrase_language_model.dart
class PhraseLanguage {
  final int id;
  final Map<String, dynamic> translations;
  final String category;

  PhraseLanguage({
    required this.id,
    required this.translations,
    required this.category,
  });

  factory PhraseLanguage.fromJson(Map<String, dynamic> json) {
    // Remove known non-language fields
    Map<String, dynamic> translations = Map<String, dynamic>.from(json);
    translations.remove('id');
    translations.remove('category');

    return PhraseLanguage(
      id: json['id'] ?? 0,
      translations: translations,
      category: json['category'] ?? '',
    );
  }

  String getTranslation(String language) {
    // Try exact match first
    if (translations.containsKey(language)) {
      return translations[language] ?? '';
    }

    // Try lowercase match
    String lowerLang = language.toLowerCase();
    if (translations.containsKey(lowerLang)) {
      return translations[lowerLang] ?? '';
    }

    // Try first available translation as fallback
    if (translations.isNotEmpty) {
      return translations.values.first ?? '';
    }

    return '';
  }
}