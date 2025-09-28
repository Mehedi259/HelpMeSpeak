class PhraseLanguage {
  final int id;
  final Map<String, String> translations;
  final String category;

  const PhraseLanguage({
    required this.id,
    required this.translations,
    required this.category,
  });

  factory PhraseLanguage.fromJson(Map<String, dynamic> json) {
    // সব field string হিসেবে সেভ হবে
    final Map<String, String> translations = {};
    json.forEach((key, value) {
      if (key != 'id' && key != 'category') {
        translations[key.toLowerCase()] = value?.toString() ?? '';
      }
    });

    return PhraseLanguage(
      id: json['id'] ?? 0,
      translations: translations,
      category: json['category'] ?? '',
    );
  }

  String getTranslation(String language) {
    final key = language.toLowerCase();
    if (translations.containsKey(key)) {
      return translations[key] ?? '';
    }
    // fallback first value
    return translations.values.isNotEmpty ? translations.values.first : '';
  }
}
