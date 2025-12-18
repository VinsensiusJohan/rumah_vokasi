import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_form_style.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/mains/models/bookmark_model.dart';
import 'package:rumah_vokasi/features/mains/services/bookmark_service.dart';
import 'package:rumah_vokasi/features/mains/services/enrollment_course_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PpBookmarkPage extends StatefulWidget {
  const PpBookmarkPage({super.key});

  @override
  State<PpBookmarkPage> createState() => _PpBookmarkPageState();
}

class _PpBookmarkPageState extends State<PpBookmarkPage> {
  String? name;
  String? token;
  String? userId;

  bool isLoading = false;

  List<BookmarkItem> bookmarkedCourses = [];

  late List<bool> isBookMarkList;

  Future<void> loadUserFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      name = prefs.getString("name");
      token = prefs.getString("access_token");
      userId = prefs.getString("user_id");
    });
    if (token != null) {
      loadData(token!, userId!);
    }
  }

  Future<void> loadData(String token, String userId) async {
    final resultBookMark = await BookmarkService().getUserBookmarksAllData(
      token,
      userId,
    );
    setState(() {
      bookmarkedCourses = resultBookMark;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadUserFromSP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bookmark",
          style: AppTextStyle.popins22w5.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left, color: AppColor.primaryBlue),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: bookmarkedCourses.isEmpty
                  ? 2
                  : bookmarkedCourses.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: AppFormStyle.searchField(
                        icon: Icons.search,
                        hint: 'Cari Bookmark',
                      ),
                    ),
                  );
                }

                if (bookmarkedCourses.isEmpty && index == 1) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Center(
                      child: Text(
                        "Belum ada Bookmark",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  );
                }

                final course = bookmarkedCourses[index - 1];
                return Card(
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey.shade100),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: course.image.isEmpty
                                  ? Image.asset(
                                      'assets/nps/course-1.png',
                                      width: 80,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.memory(
                                      base64Decode(course.image),
                                      width: 80,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.title,
                                    style: AppTextStyle.popins16.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    course.description,
                                    style: AppTextStyle.popins14,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ------ Button row --------
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: AppButtonStyle.primaryButton,
                                onPressed: () async {
                                  final addEnrollment =
                                      await EnrollmentCourseService()
                                          .addEnrollment(
                                            course.courseId,
                                            token!,
                                          );
                                  final success = await BookmarkService()
                                      .removeBookmark(
                                        token!,
                                        course.courseId,
                                        userId!,
                                      );

                                  if (addEnrollment && success && mounted) {
                                    setState(() {
                                      bookmarkedCourses.removeAt(index - 1);
                                    });
                                  }
                                },
                                child: Text(
                                  'Gabung',
                                  style: AppTextStyle.inter18.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // -------------------------
                            // SOLUSI: HAPUS ITEM SECARA LOKAL TANPA LOAD ULANG API
                            // -------------------------
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.primaryBlue.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.bookmark),
                                color: AppColor.primaryBlue,
                                onPressed: () async {
                                  final success = await BookmarkService()
                                      .removeBookmark(
                                        token!,
                                        course.courseId,
                                        userId!,
                                      );

                                  if (success && mounted) {
                                    setState(() {
                                      bookmarkedCourses.removeAt(index - 1);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
