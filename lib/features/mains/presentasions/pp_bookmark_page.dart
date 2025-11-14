import 'package:flutter/material.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_form_style.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/mains/models/course_model.dart';
import 'package:rumah_vokasi/features/mains/services/bookmark_service.dart';
import 'package:rumah_vokasi/utils/dummy_data.dart';
import 'package:rumah_vokasi/utils/app_formater.dart';

class PpBookmarkPage extends StatefulWidget {
  const PpBookmarkPage({super.key});

  @override
  State<PpBookmarkPage> createState() => _PpBookmarkPageState();
}

class _PpBookmarkPageState extends State<PpBookmarkPage> {
  List<Course> bookmarkedCourses = [];

  Future<void> _loadBookmarks() async {
    final bookmarkIDs = await BookmarkService.getBookMark();
    final filtered = courses
        .where((course) => bookmarkIDs.contains(course.id))
        .toList();

    setState(() {
      bookmarkedCourses = filtered;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
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
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: AppFormStyle.searchField(
                  icon: Icons.search,
                  hint: 'Cari Bookmark',
                ),
              ),
            ),
            if (bookmarkedCourses.isEmpty)
              Center(child: Text("Belum ada BookMark"))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bookmarkedCourses.length,
                itemBuilder: (context, index) {
                  final course = bookmarkedCourses[index];
                  return Card(
                    margin: EdgeInsets.fromLTRB(20, 5, 20, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(20),
                      side: BorderSide(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Image.asset(course.image, width: 80, height: 100, fit: BoxFit.cover,)),
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
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      course.name,
                                      style: AppTextStyle.regular12.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.textGrey,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(height: 4),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: course.bab
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                              final index = entry.key;
                                              final babName = entry.value;

                                              final colors = [
                                                AppColor.primaryBlue,
                                                AppColor.yellow,
                                                AppColor.green,
                                              ];

                                              final color =
                                                  colors[index % colors.length];

                                              return Container(
                                                margin: const EdgeInsets.only(
                                                  right: 8,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: color.withValues(
                                                    alpha: 0.15,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  babName,
                                                  style: AppTextStyle
                                                      .popins12wBold
                                                      .copyWith(color: color),
                                                ),
                                              );
                                            })
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: AppColor.iconStar,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${course.rating}',
                                          style: AppTextStyle.inter12.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '(${AppFormater.formatNumber(course.totalReviews)} Review)',
                                          style: AppTextStyle.inter12.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.textGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: AppButtonStyle.primaryButton,
                                  onPressed: () {},
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
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColor.primaryBlue.withValues(alpha: 0.2)
                                ),
                                child: Icon(
                                  Icons.bookmark,
                                  color: AppColor.primaryBlue,
                                  size: 30,
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
          ],
        ),
      ),
    );
  }
}
