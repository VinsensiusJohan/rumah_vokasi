class CourseResponse {
  final String result;
  final int code;
  final String message;
  final CourseData data;

  CourseResponse({
    required this.result,
    required this.code,
    required this.message,
    required this.data,
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    return CourseResponse(
      result: json['result'],
      code: json['code'],
      message: json['message'],
      data: CourseData.fromJson(json['data']),
    );
  }
}

class CourseData {
  final List<CourseItem> data;
  final Pagination pagination;

  CourseData({required this.data, required this.pagination});

  factory CourseData.fromJson(Map<String, dynamic> json) {
    return CourseData(
      data: (json['data'] as List)
          .map((item) => CourseItem.fromJson(item))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class CourseItem {
  final String id;
  final String title;
  final String description;
  final String price;
  final String image;
  final String? videoUrl;
  final String instructorId;
  final String status;
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

  CourseItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    this.videoUrl,
    required this.instructorId,
    required this.status,
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

  factory CourseItem.fromJson(Map<String, dynamic> json) {
    return CourseItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      videoUrl: json['video_url'],
      instructorId: json['instructor_id'],
      status: json['status'],
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
