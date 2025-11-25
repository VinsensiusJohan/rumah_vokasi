class BookmarkResponse {
  final String result;
  final int code;
  final String message;
  final List<BookmarkItem> data;

  BookmarkResponse({
    required this.result,
    required this.code,
    required this.message,
    required this.data,
  });

  factory BookmarkResponse.fromJson(Map<String, dynamic> json) {
    return BookmarkResponse(
      result: json['result'],
      code: json['code'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => BookmarkItem.fromJson(item))
          .toList(),
    );
  }
}

class BookmarkItem {
  final String courseId;
  final String title;
  final String description;
  final String image;
  final String price;
  final String subBagId;
  final String status;
  final String instructorId;
  final String createdAt;
  final String bookmarkId;
  final String bookmarkedAt;

  BookmarkItem({
    required this.courseId,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.subBagId,
    required this.status,
    required this.instructorId,
    required this.createdAt,
    required this.bookmarkId,
    required this.bookmarkedAt,
  });

  factory BookmarkItem.fromJson(Map<String, dynamic> json) {
    return BookmarkItem(
      courseId: json['course_id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      subBagId: json['sub_bag_id'],
      status: json['status'],
      instructorId: json['instructor_id'],
      createdAt: json['created_at'],
      bookmarkId: json['bookmark_id'],
      bookmarkedAt: json['bookmarked_at'],
    );
  }
}
