import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rumah_vokasi/features/mains/models/bookmark_model.dart';

class BookmarkService {
  final String baseUrl =
      "https://api-rumah-vokasi.dnabisa.com/rumah-vokasi-main";

  Future<bool> addBookmark(String token, String courseId) async {
    final url = Uri.parse("$baseUrl/student/add-bookmark");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"course_id": courseId}),
    );

    return response.statusCode == 200;
  }

  Future<bool> removeBookmark(String token, String courseId, String userId) async {
    final url = Uri.parse("$baseUrl/bookmark");

    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"course_id": courseId, "user_id": userId}),
    );

    return response.statusCode == 200;
  }

  Future<List<String>> getUserBookmarks(String token, String userId) async {
    final url = Uri.parse(
      "$baseUrl/student/get-course-by-bookmark?user_id=$userId",
    );

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      List<dynamic> list = body["data"];

      // Ambil hanya course_id
      List<String> courseIds = list
          .map((item) => item["course_id"] as String)
          .toList();

      return courseIds;
    }

    return [];
  }

  Future<List<BookmarkItem>> getUserBookmarksAllData(String token, String userId) async {
  final url = Uri.parse(
      "$baseUrl/student/get-course-by-bookmark?user_id=$userId");

  final response = await http.get(
    url,
    headers: {"Authorization": "Bearer $token"},
  );

  if (response.statusCode == 200) {
    final jsonMap = jsonDecode(response.body);
    final bookmarkResponse = BookmarkResponse.fromJson(jsonMap);
    return bookmarkResponse.data;
  }

  return [];
}

}
