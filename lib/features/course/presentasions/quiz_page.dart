import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/course/models/quiz_model.dart';
import 'package:rumah_vokasi/features/course/services/quiz_service.dart';
import 'package:rumah_vokasi/features/mains/models/course_section_model.dart';
import 'package:rumah_vokasi/features/mains/services/enrollment_course_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizPage extends StatefulWidget {
  final String courseID;
  final String lessonID;
  const QuizPage({super.key, required this.courseID, required this.lessonID});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  CourseSectionData? course;
  QuizData? quiz;

  String? token;
  bool isLoading = false;

  Future<void> loadData(String courseID) async {
    if (widget.lessonID.isEmpty) {
      throw Exception("LessonID NULL → tidak bisa load quiz");
    }

    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("access_token");

    try {
      final courseResponse = await EnrollmentCourseService().getCourseByID(
        courseID,
      );
      final quizResponse = token != null
          ? await QuizService().getQuizByLessonId(widget.lessonID, token!)
          : null;

      // 🚀 ini bagian penting!
      setState(() {
        course = courseResponse;
        quiz = quizResponse;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error saat load data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadData(widget.courseID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Detail Kuis",
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
          : (course == null || quiz == null)
          ? Center(child: Text("Gagal memuat data"))
          : Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 3,
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
                                  style: AppTextStyle.popins12wBold.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.textGrey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              //const SizedBox(width: 10),
                              //Icon(Icons.star, color: AppColor.iconStar, size: 20),
                              //const SizedBox(width: 10),
                              //Text(
                              //  '4.3',
                              //  style: AppTextStyle.popins14.copyWith(
                              //    fontWeight: FontWeight.w500,
                              //    color: AppColor.textGrey,
                              //  ),
                              //),
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
                          //SingleChildScrollView(
                          //  scrollDirection: Axis.horizontal,
                          //  child: Row(
                          //    children: bab.asMap().entries.map((entry) {
                          //      final index = entry.key;
                          //      final babName = entry.value;
                          //      final colors = [
                          //        AppColor.primaryBlue,
                          //        AppColor.yellow,
                          //        AppColor.green,
                          //      ];
                          //      final color = colors[index % colors.length];
                          //      return Container(
                          //        margin: const EdgeInsets.only(right: 8),
                          //        padding: const EdgeInsets.symmetric(
                          //          horizontal: 12,
                          //          vertical: 6,
                          //        ),
                          //        decoration: BoxDecoration(
                          //          color: color.withValues(alpha: 0.15),
                          //          borderRadius: BorderRadius.circular(12),
                          //        ),
                          //        child: Text(
                          //          babName,
                          //          style: AppTextStyle.popins12wBold.copyWith(
                          //            color: color,
                          //            fontWeight: FontWeight.w500,
                          //          ),
                          //        ),
                          //      );
                          //    }).toList(),
                          //  ),
                          //),
                          const SizedBox(height: 8),
                          //Row(
                          //  crossAxisAlignment: CrossAxisAlignment.center,
                          //  children: [
                          //    Expanded(
                          //      child: ClipRRect(
                          //        borderRadius: BorderRadius.circular(8),
                          //        child: LinearProgressIndicator(
                          //          value: 0.7,
                          //          backgroundColor: Colors.grey.shade200,
                          //          valueColor: AlwaysStoppedAnimation<Color>(
                          //            AppColor.green2,
                          //          ),
                          //          minHeight: 10,
                          //        ),
                          //      ),
                          //    ),
                          //    const SizedBox(width: 10),
                          //    Text(
                          //      "${((0.7) * 100).toStringAsFixed(0)}%",
                          //      style: AppTextStyle.popins12wBold,
                          //    ),
                          //  ],
                          //),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                    ),
                    padding: EdgeInsets.all(25),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColor.primaryBlue.withValues(alpha: 0.2),
                          ),
                          padding: EdgeInsets.all(15),
                          child: SvgPicture.asset(
                            'assets/icons/NotePencil.svg',
                            height: 25,
                            width: 25,
                            colorFilter: ColorFilter.mode(
                              AppColor.primaryBlue,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quiz!.title,
                                style: AppTextStyle.popins12wBold.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/open_book.svg',
                                    width: 15,
                                    height: 15,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      (quiz!.description == "") ? " • Kuis" : " • ${quiz!.description!}",
                                      style: AppTextStyle.popins10w6.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/NotePencil.svg',
                                    width: 15,
                                    height: 15,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Text(
                                    quiz!.answerType == "OPTION"
                                        ? " • Pilihan Ganda"
                                        : " • Isian",
                                    style: AppTextStyle.popins10w6.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/stack.svg',
                                    width: 15,
                                    height: 15,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  //Text(
                                  //  " • 50 Soal",
                                  //  style: AppTextStyle.popins10w6.copyWith(
                                  //    fontWeight: FontWeight.w400,
                                  //  ),
                                  //),
                                  //const SizedBox(width: 20),
                                  SvgPicture.asset(
                                    'assets/icons/clock.svg',
                                    width: 15,
                                    height: 15,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Text(
                                    " • ${quiz!.durationMinutes} Menit",
                                    style: AppTextStyle.popins10w6.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
