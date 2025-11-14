class PaymentHistory {
  final String tanggal;
  final String jam;
  final List<CoursePayment> listKursus;

  PaymentHistory({
    required this.tanggal,
    required this.jam,
    required this.listKursus,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
    tanggal: json['tanggal'] as String,
    jam: json['jam'] as String,
    listKursus: (json['list_kursus'] as List<dynamic>)
        .map((e) => CoursePayment.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'tanggal': tanggal,
    'jam': jam,
    'list_kursus': listKursus.map((e) => e.toJson()).toList(),
  };

  int get totalCourse => listKursus.length;

  double get totalPrice =>
      listKursus.fold(0, (sum, listKursus) => sum + listKursus.harga);
}

class CoursePayment {
  final String image;
  final String title;
  final String name;
  final List<String> bab;
  final double harga;
  final String statusPembayaran;

  CoursePayment({
    required this.image,
    required this.title,
    required this.name,
    required this.bab,
    required this.harga,
    required this.statusPembayaran,
  });

  factory CoursePayment.fromJson(Map<String, dynamic> json) => CoursePayment(
    image: json['image'] as String,
    title: json['title'] as String,
    name: json['name'] as String,
    bab: List<String>.from(json['bab'] ?? []),
    harga: (json['harga'] as num).toDouble(),
    statusPembayaran: json['status_pembayaran'] as String,
  );

  Map<String, dynamic> toJson() => {
    'image': image,
    'title': title,
    'name': name,
    'bab': bab,
    'harga': harga,
    'status_pembayaran': statusPembayaran,
  };
}
