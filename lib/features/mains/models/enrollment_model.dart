class EnrollmentResponse {
  final String result;
  final int code;
  final String message;
  final EnrollmentData data;

  EnrollmentResponse({
    required this.result,
    required this.code,
    required this.message,
    required this.data,
  });

  factory EnrollmentResponse.fromJson(Map<String, dynamic> json) {
    return EnrollmentResponse(
      result: json['result'],
      code: json['code'],
      message: json['message'],
      data: EnrollmentData.fromJson(json['data']),
    );
  }
}

class EnrollmentData {
  final List<EnrollmentItem> data;
  final Pagination pagination;

  EnrollmentData({required this.data, required this.pagination});

  factory EnrollmentData.fromJson(Map<String, dynamic> json) {
    return EnrollmentData(
      data: (json['data'] as List)
          .map((item) => EnrollmentItem.fromJson(item))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class EnrollmentItem {
  final String enrollmentId;
  final String enrolledAt;
  final String courseId;
  final String courseTitle;     
  final String description;
  final String price;
  final String image;           
  final String? videoUrl;
  final String courseStatus;
  final String instructorId;
  final String instructorName; 
  final String? subBagId;
  final String? subBagTitle;
  final String? subId;
  final String? subTitle;
  final String? kompetensiId;
  final String? kompetensiTitle;
  final String? programId;
  final String? programTitle;
  final String? bidangId;
  final String? bidangTitle;

  EnrollmentItem({
    required this.enrollmentId,
    required this.enrolledAt,
    required this.courseId,
    required this.courseTitle,
    required this.description,
    required this.price,
    required this.image,
    this.videoUrl,
    required this.courseStatus,
    required this.instructorId,
    required this.instructorName,
    this.subBagId,
    this.subBagTitle,
    this.subId,
    this.subTitle,
    this.kompetensiId,
    this.kompetensiTitle,
    this.programId,
    this.programTitle,
    this.bidangId,
    this.bidangTitle,
  });

  factory EnrollmentItem.fromJson(Map<String, dynamic> json) {
    return EnrollmentItem(
      enrollmentId: json['enrollment_id'],
      enrolledAt: json['enrolled_at'],
      courseId: json['course_id'],
      courseTitle: json['course_title'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      videoUrl: json['video_url'],
      courseStatus: json['course_status'],
      instructorId: json['instructor_id'],
      instructorName: json['instructor_name'],

      subBagId: json['sub_bag_id'],
      subBagTitle: json['sub_bag_title'],
      subId: json['sub_id'],
      subTitle: json['sub_title'],
      kompetensiId: json['kompetensi_id'],
      kompetensiTitle: json['kompetensi_title'],
      programId: json['program_id'],
      programTitle: json['program_title'],
      bidangId: json['bidang_id'],
      bidangTitle: json['bidang_title'],
    );
  }
}

class Pagination {
  final int currentPage;
  final int perPage;
  final int totalItems;
  final int totalPages;

  Pagination({
    required this.currentPage,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      perPage: json['per_page'],
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
    );
  }
}
