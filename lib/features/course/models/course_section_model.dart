class CourseSection {
  final String title;
  final int total;
  final SectionType type;
  CourseSection({
    required this.title,
    required this.total,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'totalMateri': total,
    'type': type.name,
  };

  factory CourseSection.fromJson(Map<String, dynamic> json) {
    return CourseSection(
      title: json['title'] as String,
      total: json['totalMateri'] as int,
      type: SectionTypeExtension.fromString(json['type']),
    );
  }
}

enum SectionType { materi, kuis }

extension SectionTypeExtension on SectionType {
  static SectionType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'materi':
        return SectionType.materi;
      case 'kuis':
        return SectionType.kuis;
      default:
        throw ArgumentError('Tipe section tidak dikenal: $value');
    }
  }
}

extension SectionTypeExtensionReturn on SectionType {
  String get label {
    switch (this) {
      case SectionType.materi:
        return 'Materi';
      case SectionType.kuis:
        return 'Kuis';
    }
  }
}
