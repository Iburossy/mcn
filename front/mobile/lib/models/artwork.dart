class Artwork {
  final String id;
  final String artworkId;
  final Map<String, String> title;
  final Map<String, String> description;
  final String artist;
  final String period;
  final String category;
  final List<String> images;
  final Map<String, String>? audioGuide;
  final String? qrCode;
  final DateTime createdAt;

  Artwork({
    required this.id,
    required this.artworkId,
    required this.title,
    required this.description,
    required this.artist,
    required this.period,
    required this.category,
    required this.images,
    this.audioGuide,
    this.qrCode,
    required this.createdAt,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['_id'] ?? json['id'],
      artworkId: json['artworkId'] ?? '',
      title: Map<String, String>.from(json['title'] ?? {}),
      description: Map<String, String>.from(json['description'] ?? {}),
      artist: json['artist'] ?? '',
      period: json['period'] ?? '',
      category: json['category'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      audioGuide: json['audioGuide'] != null 
          ? Map<String, String>.from(json['audioGuide']) 
          : null,
      qrCode: json['qrCode'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'artworkId': artworkId,
      'title': title,
      'description': description,
      'artist': artist,
      'period': period,
      'category': category,
      'images': images,
      'audioGuide': audioGuide,
      'qrCode': qrCode,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Obtenir le titre dans la langue actuelle
  String getTitle(String language) {
    return title[language] ?? title['fr'] ?? title['en'] ?? '';
  }

  // Obtenir la description dans la langue actuelle
  String getDescription(String language) {
    return description[language] ?? description['fr'] ?? description['en'] ?? '';
  }

  // Obtenir la première image
  String? get primaryImage {
    return images.isNotEmpty ? images.first : null;
  }
}
