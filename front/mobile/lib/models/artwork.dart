class Artwork {
  final String id;
  final String artworkId;
  final Map<String, String> title;
  final Map<String, String> description;
  final String artist;
  final String period;
  final String category;
  final String origin;
  final List<String> images;
  final Map<String, String>? audio;
  final Map<String, String>? audioGuide;
  final Map<String, String>? videoGuide;
  final Map<String, String>? culturalContext;
  final String? video;
  final String? model3D;
  final String? qrCode;
  final List<String>? materials;
  final Map<String, dynamic>? dimensions;
  final int viewCount;
  final DateTime createdAt;

  Artwork({
    required this.id,
    required this.artworkId,
    required this.title,
    required this.description,
    required this.artist,
    required this.period,
    required this.category,
    required this.origin,
    required this.images,
    this.audio,
    this.audioGuide,
    this.videoGuide,
    this.culturalContext,
    this.video,
    this.model3D,
    this.qrCode,
    this.materials,
    this.dimensions,
    this.viewCount = 0,
    required this.createdAt,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['_id'] ?? json['id'],
      artworkId: json['artworkId'] ?? json['qrCode'] ?? '',
      title: Map<String, String>.from(json['title'] ?? {}),
      description: Map<String, String>.from(json['description'] ?? {}),
      artist: json['artist'] ?? 'Inconnu',
      period: json['period'] ?? '',
      category: json['category'] ?? '',
      origin: json['origin'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      audio: json['audio'] != null 
          ? Map<String, String>.from(json['audio']) 
          : null,
      audioGuide: json['audioGuide'] != null 
          ? Map<String, String>.from(json['audioGuide']) 
          : null,
      videoGuide: json['videoGuide'] != null 
          ? Map<String, String>.from(json['videoGuide']) 
          : null,
      culturalContext: json['culturalContext'] != null 
          ? Map<String, String>.from(json['culturalContext']) 
          : null,
      video: json['video'],
      model3D: json['model3D'],
      qrCode: json['qrCode'],
      materials: json['materials'] != null 
          ? List<String>.from(json['materials']) 
          : null,
      dimensions: json['dimensions'],
      viewCount: json['viewCount'] ?? 0,
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

  // Obtenir le contexte culturel dans la langue actuelle
  String? getCulturalContext(String language) {
    if (culturalContext == null) return null;
    return culturalContext![language] ?? culturalContext!['fr'] ?? culturalContext!['en'];
  }

  // Obtenir l'URL audio dans la langue actuelle
  String? getAudio(String language) {
    if (audio == null) return null;
    return audio![language] ?? audio!['fr'] ?? audio!['en'];
  }

  // Obtenir l'URL audio-guide dans la langue actuelle
  String? getAudioGuide(String language) {
    if (audioGuide == null) return null;
    return audioGuide![language] ?? audioGuide!['fr'] ?? audioGuide!['en'];
  }

  // Obtenir l'URL vidéo-guide dans la langue actuelle
  String? getVideoGuide(String language) {
    if (videoGuide == null) return null;
    return videoGuide![language] ?? videoGuide!['fr'] ?? videoGuide!['en'];
  }

  // Formater les dimensions
  String? getFormattedDimensions() {
    if (dimensions == null) return null;
    final h = dimensions!['height'];
    final w = dimensions!['width'];
    final d = dimensions!['depth'];
    final unit = dimensions!['unit'] ?? 'cm';
    
    if (h != null && w != null && d != null) {
      return '$h × $w × $d $unit';
    } else if (h != null && w != null) {
      return '$h × $w $unit';
    }
    return null;
  }

  // Obtenir la première image
  String? get primaryImage {
    return images.isNotEmpty ? images.first : null;
  }
}
