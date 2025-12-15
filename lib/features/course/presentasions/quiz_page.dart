import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumah_vokasi/utils/app_formater.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/course/models/attempt_result_model.dart';
import 'package:rumah_vokasi/features/course/models/quiz_model.dart';
import 'package:rumah_vokasi/features/course/presentasions/quiz_work_page.dart';
import 'package:rumah_vokasi/features/course/services/attempt_result_service.dart';
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
  List<QuizData> quiz = [];
  Map<String, QuizAttemptInfo> quizAttempt = {};

  String? token;
  bool isLoading = false;

  Future<void> loadData(String courseID) async {
    if (widget.lessonID.isEmpty) {
      throw Exception("LessonID NULL : tidak bisa load quiz");
    }

    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("access_token");

    try {
      final courseResponse = await EnrollmentCourseService().getCourseByID(
        courseID,
      );
      final quizResponse = token != null
          ? await QuizService().getQuizByLessonId(widget.lessonID, token!)
          : <QuizData>[];

      final attemptMap = token != null
          ? await QuizResultService().getQuizAttemptMap(
              token: token!,
              lessonId: widget.lessonID,
            )
          : <String, QuizAttemptInfo>{};

      setState(() {
        course = courseResponse;
        quiz = quizResponse;
        quizAttempt = attemptMap;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData(widget.courseID);
    });
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
          : (course == null || quiz.isEmpty)
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: quiz.length,
                      itemBuilder: (context, index) {
                        final quizShow = quiz[index];
                        final attemptInfo = quizAttempt[quizShow.id];
                        final hasAttempt = attemptInfo?.hasAttempt ?? false;
                        return GestureDetector(
                          onTap: () {
                            hasAttempt
                                ? null
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => QuizWorkPage(
                                        quizID: quizShow.id,
                                        courseID: widget.courseID,
                                      ),
                                    ),
                                  );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 2,
                              ),
                            ),
                            padding: EdgeInsets.all(25),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColor.primaryBlue.withValues(
                                      alpha: 0.2,
                                    ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        quizShow.title,
                                        style: AppTextStyle.popins12wBold
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 2,
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/icons/open_book.svg',
                                              width: 15,
                                              height: 15,
                                            ),
                                          ),
                                          Text(" • "),
                                          Expanded(
                                            child: Text(
                                              (quizShow.description == null ||
                                                      quizShow.description!
                                                          .trim()
                                                          .isEmpty)
                                                  ? "Kuis"
                                                  : quizShow.description!,
                                              style: AppTextStyle.popins10w6
                                                  .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                            quizShow.answerType == "OPTION"
                                                ? " • Pilihan Ganda"
                                                : " • Isian",
                                            style: AppTextStyle.popins10w6
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/scoreboard.svg',
                                            width: 15,
                                            height: 15,
                                            colorFilter: ColorFilter.mode(
                                              Colors.black,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          Text(
                                            " • ${AppFormater.formatScore(attemptInfo?.score)}",
                                            style: AppTextStyle.popins10w6
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                          const SizedBox(width: 20),
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
                                            " • ${quizShow.durationMinutes} Menit",
                                            style: AppTextStyle.popins10w6
                                                .copyWith(
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
