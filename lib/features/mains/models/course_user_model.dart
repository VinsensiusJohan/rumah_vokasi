class CourseUser {
  final String id;
  final String image;
  final String title;
  final String name;
  final List<String> bab;
  final double progress;

  CourseUser({
    required this.image,
    required this.title,
    required this.name,
    required this.bab,
    required this.progress,
  }) : id = title
           .toLowerCase()
           .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
           .replaceAll(RegExp(r'\s+'), '-');

  factory CourseUser.fromJson(Map<String, dynamic> json) => CourseUser(
    image: json['image'] as String,
    title: json['title'] as String,
    name: json['name'] as String,
    bab: List<String>.from(json['bab'] ?? []),
    progress: json['progress'],
  );

  Map<String, dynamic> toJson() => {
    'image': image,
    'title': title,
    'name': name,
    'bab': bab,
    'progress': progress,
  };
}
