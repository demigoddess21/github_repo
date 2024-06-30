class Repository {
  final String name;
  final String description;
  final String url;
  final String language;

  Repository({
    required this.name,
    required this.description,
    required this.url,
    required this.language,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'],
      description: json['description'] ?? 'No description',
      url: json['url'],
      language: json['primaryLanguage'] != null
          ? json['primaryLanguage']['name']
          : 'Unknown',
    );
  }
}
