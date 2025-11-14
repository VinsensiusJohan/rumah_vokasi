class Course {
  final String id;
  final String image;
  final String title;
  final String name;
  final double rating;
  final int totalReviews;
  final List<String> bab;

  Course({
    required this.image,
    required this.title,
    required this.name,
    required this.rating,
    required this.totalReviews,
    required this.bab,
  }) : id = title
           .toLowerCase()
           .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
           .replaceAll(RegExp(r'\s+'), '-');

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    image: json['image'] as String,
    title: json['title'] as String,
    name: json['name'] as String,
    rating: (json['rating'] as num).toDouble(),
    totalReviews: json['total_reviews'] as int,
    bab: List<String>.from(json['bab'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'image': image,
    'title': title,
    'name': name,
    'rating': rating,
    'total_reviews': totalReviews,
    'bab': bab,
  };
}
