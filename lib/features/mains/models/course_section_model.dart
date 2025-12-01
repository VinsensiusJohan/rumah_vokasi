class CourseSectionResponse {
  final String result;
  final int code;
  final String message;
  final CourseSectionData data;

  CourseSectionResponse({
    required this.result,
    required this.code,
    required this.message,
    required this.data,
  });

  factory CourseSectionResponse.fromJson(Map<String, dynamic> json) {
    return CourseSectionResponse(
      result: json['result'],
      code: json['code'],
      message: json['message'],
      data: CourseSectionData.fromJson(json['data']),
    );
  }
}

class CourseSectionData {
  final String id;
  final String title;
  final String description;
  final String price;
  final String image;
  final String? videoUrl;
  final String instructorId;
  final String subBagId;
  final String status;
  final String createdBy;
  final String creatorUserType;
  final String instructorName;

  CourseSectionData({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    this.videoUrl,
    required this.instructorId,
    required this.subBagId,
    required this.status,
    required this.createdBy,
    required this.creatorUserType,
    required this.instructorName,
  });

  factory CourseSectionData.fromJson(Map<String, dynamic> json) {
    return CourseSectionData(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      videoUrl: json['video_url'],
      instructorId: json['instructor_id'],
      subBagId: json['sub_bag_id'],
      status: json['status'],
      createdBy: json['created_by'],
      creatorUserType: json['creator_user_type'],
      instructorName: json['instructor_name'],
    );
  }
}
