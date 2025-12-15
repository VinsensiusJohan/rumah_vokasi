import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/course/models/lesson_model.dart';
import 'package:rumah_vokasi/features/course/presentasions/lessons_page.dart';
import 'package:rumah_vokasi/features/course/presentasions/quiz_page.dart';
import 'package:rumah_vokasi/features/course/services/lesson_service.dart';
import 'package:rumah_vokasi/features/mains/models/course_section_model.dart';
import 'package:rumah_vokasi/features/course/models/section_model.dart';
import 'package:rumah_vokasi/features/mains/services/enrollment_course_service.dart';
import 'package:rumah_vokasi/features/course/services/section_service.dart';

class SectionPage extends StatefulWidget {
  final String courseID;
  const SectionPage({super.key, required this.courseID});

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  CourseSectionData? course;
  List<SectionItem> section = [];

  Map<String, List<LessonItem>> lessonsBySection = {};

  bool isLoading = false;
  final random = Random();
  late String fallbackImages;

  final List<String> defaultImages = [
    'assets/nps/course-1.png',
    'assets/nps/course-2.png',
    'assets/nps/course-3.png',
    'assets/nps/course-4.png',
  ];

  String getRandomDefaultImage() {
    return defaultImages[random.nextInt(defaultImages.length)];
  }

  Future<void> loadData(String courseID) async {
    try {
      final courseResponse = await EnrollmentCourseService().getCourseByID(
        courseID,
      );
      course = courseResponse;
    } catch (e) {
      return;
    }

    try {
      final sectionResponse = await SectionService().getSectionByCourseID(
        courseID,
      );
      section = sectionResponse;
    } catch (e) {
      debugPrint("$e");
    }
    await loadLessons();

    setState(() => isLoading = false);
  }

  Future<void> loadLessons() async {
    for (var sec in section) {
      try {
        final lessons = await LessonService().getLessonBySectionId(sec.id);
        lessonsBySection[sec.id] = lessons;
      } catch (e) {
        lessonsBySection[sec.id] = [];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadData(widget.courseID);
    fallbackImages = getRandomDefaultImage();
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: course!.image.isEmpty
                        ? Image.asset(
                            fallbackImages,
                            width: screenwidth,
                            height: 180,
                            fit: BoxFit.cover,
                          )
                        : Image.memory(
                            base64Decode(course!.image),
                            width: screenwidth,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.chevron_left_outlined,
                            color: AppColor.primaryBlue,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    top: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                            width: 1,
                                          ),
                                        ),
                                        child: Image.asset(
                                          'assets/images/eula-slide-1.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          course!.instructorName,
                                          style: AppTextStyle.popins12wBold
                                              .copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.textGrey,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    course!.title,
                                    style: AppTextStyle.popins14.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    course!.description,
                                    style: AppTextStyle.popins10w6.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
        
                              child: Material(
                                color: Colors.white,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    dividerColor: Colors.transparent,
                                    listTileTheme: ListTileThemeData(
                                      textColor: Colors.black,
                                      iconColor: Colors.black,
                                    ),
                                    expansionTileTheme: ExpansionTileThemeData(
                                      iconColor: Colors.black,
                                      collapsedIconColor: Colors.black,
                                    ),
                                  ),
                                  child: ExpansionTile(
                                    title: Text(
                                      "Deskripsi Kelas",
                                      style: AppTextStyle.popins14.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    children: [ListTile(title: Text("data"))],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
        
                          // Section------------------------------------------------------------------------------
                          Text(
                            "Section(${section.length})",
                            style: AppTextStyle.popins16.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 10),
                              itemCount: section.length,
                              itemBuilder: (context, index) {
                                final sectionData = section[index];
                                final lessonsData =
                                    lessonsBySection[sectionData.id];
                                final quizCount = (lessonsData ?? [])
                                    .where((l) => l.contentType == "QUIZ")
                                    .length;
                                final materiCount = (lessonsData ?? [])
                                    .where((l) => l.contentType == "YOUTUBE")
                                    .length;
                                return Card(
                                  margin: EdgeInsets.only(bottom: 10),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 2,
                                    ),
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent,
                                      listTileTheme: ListTileThemeData(
                                        textColor: Colors.black,
                                        iconColor: Colors.black,
                                      ),
                                      expansionTileTheme: ExpansionTileThemeData(
                                        iconColor: Colors.black,
                                        collapsedIconColor: Colors.black,
                                      ),
                                    ),
                                    child: ExpansionTile(
                                      
                                      tilePadding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 5,
                                        bottom: 5,
                                      ),
                                      title: Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                5,
                                              ),
                                              color: AppColor.primaryBlue
                                                  .withValues(alpha: 0.2),
                                            ),
                                            child: Text(
                                              index + 1 < 10
                                                  ? '0${index + 1}'
                                                  : '${index + 1}',
                                              style: AppTextStyle.popins16
                                                  .copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColor.primaryBlue,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  sectionData.title,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: AppTextStyle.popins14
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/icons/NotePencil.svg',
                                                      width: 15,
                                                      height: 15,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                            Colors.black,
                                                            BlendMode.srcIn,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      materiCount == 0
                                                          ? ""
                                                          : '• $materiCount materi',
                                                      style: AppTextStyle
                                                          .popins10w6
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                AppColor.textGrey,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      quizCount == 0
                                                          ? ''
                                                          : '• $quizCount kuis',
                                                      style: AppTextStyle
                                                          .popins10w6
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                AppColor.textGrey,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      children: [
                                        if (lessonsData == null)
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: CircularProgressIndicator(),
                                          )
                                        else if (lessonsData.isEmpty)
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text("Tidak ada lesson"),
                                          )
                                        else
                                          ...([...lessonsData]..sort(
                                                (a, b) => int.parse(a.lessonOrder)
                                                    .compareTo(
                                                      int.parse(b.lessonOrder),
                                                    ),
                                              ))
                                              .map((lesson) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    if (lesson.contentType ==
                                                        "YOUTUBE") {
                                                      if (lesson.videoUrl !=
                                                              null &&
                                                          lesson.videoUrl!
                                                              .trim()
                                                              .isNotEmpty &&
                                                          (lesson.videoUrl!
                                                                  .contains(
                                                                    "youtube.com",
                                                                  ) ||
                                                              lesson.videoUrl!
                                                                  .contains(
                                                                    "youtu.be",
                                                                  ))) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                LessonsPage(
                                                                  lessonID:
                                                                      lesson.id,
                                                                  youtubeUrl: lesson
                                                                      .videoUrl!,
                                                                  title: lesson
                                                                      .title,
                                                                  sectionID: sectionData.id,
                                                                ),
                                                          ),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              "Link YouTube tidak tersedia.",
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    } else if (lesson
                                                            .contentType ==
                                                        "QUIZ") {
                                                      if (lesson.id
                                                          .trim()
                                                          .isNotEmpty) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                QuizPage(
                                                                  courseID: widget
                                                                      .courseID,
                                                                  lessonID:
                                                                      lesson.id,
                                                                ),
                                                          ),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              "Kuis tidak tersedia.",
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: 5,
                                                      bottom: 15,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                          left: 10,
                                                          top: 10,
                                                          bottom: 10,
                                                          right: 10,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      border: Border.all(
                                                        color:
                                                            Colors.grey.shade200,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              lesson.title,
                                                              style: AppTextStyle
                                                                  .popins12wBold
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: AppColor
                                                                        .primaryBlue,
                                                                  ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                lesson.contentType ==
                                                                        "YOUTUBE"
                                                                    ? SvgPicture.asset(
                                                                        'assets/icons/play.svg',
                                                                        height:
                                                                            15,
                                                                        width: 15,
                                                                        colorFilter: ColorFilter.mode(
                                                                          Colors
                                                                              .black,
                                                                          BlendMode
                                                                              .srcIn,
                                                                        ),
                                                                      )
                                                                    : SvgPicture.asset(
                                                                        'assets/icons/NotePencil.svg',
                                                                        height:
                                                                            15,
                                                                        width: 15,
                                                                        colorFilter: ColorFilter.mode(
                                                                          Colors
                                                                              .black,
                                                                          BlendMode
                                                                              .srcIn,
                                                                        ),
                                                                      ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  "• ${lesson.title}",
                                                                  style: AppTextStyle
                                                                      .popins10w6
                                                                      .copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: AppColor
                                                                            .textGrey,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        Icon(
                                                          Icons
                                                              .chevron_right_outlined,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
