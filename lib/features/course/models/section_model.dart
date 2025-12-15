class SectionsResponse {
  final String result;
  final int code;
  final String message;
  final List<SectionItem> data;

  SectionsResponse({
    required this.result,
    required this.code,
    required this.message,
    required this.data,
  });

  factory SectionsResponse.fromJson(Map<String, dynamic> json) {
    return SectionsResponse(
      result: json['result'],
      code: json['code'],
      message: json['message'],
      data: (json['data'] as List<dynamic>)
          .map((item) => SectionItem.fromJson(item))
          .toList(),
    );
  }
}

class SectionItem {
  final String id;
  final String title;
  final String courseId;
  final String courseTitle;
  final String sectionOrder;
  final String createdAt;

  SectionItem({
    required this.id,
    required this.title,
    required this.courseId,
    required this.courseTitle,
    required this.sectionOrder,
    required this.createdAt,
  });

  factory SectionItem.fromJson(Map<String, dynamic> json) {
    return SectionItem(
      id: json['id'],
      title: json['title'],
      courseId: json['course_id'],
      courseTitle: json['course_title'],
      sectionOrder: json['section_order'],
      createdAt: json['created_at'],
    );
  }
}
