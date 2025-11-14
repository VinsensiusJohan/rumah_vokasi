class Certificate {
  final String image;
  final String title;
  final String name;
  final List<String> bab;

  Certificate({
    required this.image,
    required this.title,
    required this.name,
    required this.bab,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) =>
      Certificate(
        image: json['image'] as String,
        title: json['title'] as String,
        name: json['name'] as String,
        bab: List<String>.from(json['bab'] ?? []),
      );

  Map<String, dynamic> toJson() => {
    'image' : image,
    'title' : title,
    'name' : name,
    'bab' : bab
  };
}
