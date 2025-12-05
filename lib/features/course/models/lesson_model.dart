class LessonResponse {
  final String result;
  final int code;
  final String message;
  final List<LessonItem> data;

  LessonResponse({
    required this.result,
    required this.code,
    required this.message,
    required this.data,
  });

  factory LessonResponse.fromJson(Map<String, dynamic> json) {
    return LessonResponse(
      result: json['result'],
      code: json['code'],
      message: json['message'],
      data: (json['data'] as List<dynamic>)
      .map((item) => LessonItem.fromJson(item))
      .toList(),
    );
  }
}

class LessonItem {
  final String id;
  final String sectionId;
  final String title;
  final String contentType;
  final String? videoUrl;
  final String? file;
  final String? thumbnail;
  final String lessonOrder;
  final String? summary;
  final String? parentId;

  LessonItem({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.contentType,
    this.videoUrl,
    this.file,
    this.thumbnail,
    required this.lessonOrder,
    this.summary,
    this.parentId,
  });

  factory LessonItem.fromJson(Map<String, dynamic> json) {
    return LessonItem(
      id: json['id'],
      sectionId: json['section_id'],
      title: json['title'],
      contentType: json['content_type'],
      videoUrl: json['video_url'],
      file: json['file'],
      thumbnail: json['thumbnail'],
      lessonOrder: json['lessons_order'],
      summary: json['summary'],
      parentId: json['parent_id'],
    );
  }
}
