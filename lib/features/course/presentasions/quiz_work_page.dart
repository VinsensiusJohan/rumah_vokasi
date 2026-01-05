import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/course/models/question_option_model.dart';
import 'package:rumah_vokasi/features/course/models/question_text_model.dart';
import 'package:rumah_vokasi/features/course/models/quiz_info_model.dart';
import 'package:rumah_vokasi/features/course/presentasions/section_page.dart';
import 'package:rumah_vokasi/features/course/services/question_textoption_service.dart';
import 'package:rumah_vokasi/features/course/services/quiz_service.dart';
import 'package:rumah_vokasi/utils/dummy_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizWorkPage extends StatefulWidget {
  final String quizID;
  final String courseID;
  final bool isPreview;
  const QuizWorkPage({
    super.key,
    required this.quizID,
    required this.courseID,
    this.isPreview = false,
  });

  @override
  State<QuizWorkPage> createState() => _QuizWorkPageState();
}

class _QuizWorkPageState extends State<QuizWorkPage> {
  final PageController pageController = PageController();
  int currentIndex = 0;
  final remainingTime = ValueNotifier<Duration>(Duration.zero);
  Timer? _timer;
  Map<String, List<AnswerItem>> shuffledAnswers = {};
  final Map<String, String> selectedAnswers = {};
  Map<String, bool> markedQuestions = {};
  bool isExpanded = false;
  String? token;
  String? attemptId;
  bool isLoading = true;

  QuizInfo? quizInfo;
  List<QuestionItem>? questions;
  List<EssayQuestion>? questionEssay;

  Future<void> loadData(String quizID) async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("access_token");

    if (token == null) return;

    try {
      attemptId = await QuizService().getQuizAttempt(token!, quizID);

      final resultquiz = await QuizQuestionService().getQuizOption(
        quizID,
        token!,
      );

      if (resultquiz != null) {
        final shuffled = <String, List<AnswerItem>>{};
        final marked = <String, bool>{};

        for (final q in resultquiz.questions) {
          final answers = List<AnswerItem>.from(q.answers);
          answers.shuffle(Random(q.questionId.hashCode));
          shuffled[q.questionId] = answers;
          marked[q.questionId] = false;
        }

        final endTime = DateTime.now().add(
          Duration(minutes: int.tryParse(resultquiz.quiz.durationMinutes)!),
        );
        await prefs.setString('quiz_end_time', endTime.toIso8601String());

        start(endTime);

        setState(() {
          quizInfo = resultquiz.quiz;
          questions = resultquiz.questions;
          shuffledAnswers = shuffled;
          markedQuestions = marked;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("$e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void start(DateTime endTime) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final diff = endTime.difference(DateTime.now());
      if (diff.isNegative) {
        remainingTime.value = Duration.zero;
        t.cancel();
      } else {
        remainingTime.value = diff;
      }
    });
  }

  bool isQuestionAnswered(String questionId) {
    return selectedAnswers[questionId] != null; // sudah pilih jawaban
  }

  bool isQuestionMarked(String questionId) {
    return markedQuestions[questionId] == true; // ditandai
  }

  void _nextQuestion() {
    if (currentIndex < questions!.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevQuestion() {
    if (currentIndex > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isPreview) {
      quizInfo = dummyQuizInfo;
      questionEssay = dummyEssayQuestions;
      isLoading = false;
    } else {
      loadData(widget.quizID);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (quizInfo == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (quizInfo!.answerType == "OPTION") {
      if (questions == null || questions!.isEmpty) {
        return const Scaffold(
          body: Center(child: Text("Failed to load Quiz type OPTION")),
        );
      }
      final totalQuestions = questions!.length;

      return buildOptionQuizPage(quizInfo!, totalQuestions);
    }

    if (quizInfo!.answerType == "TEXT") {
      if (questionEssay == null || questionEssay!.isEmpty) {
        return const Scaffold(
          body: Center(child: Text("Failed to load Quiz type TEXT")),
        );
      }
      final totalQuestions = questionEssay!.length;
      return buildEssayQuizPage(quizInfo!, totalQuestions);
    }

    if (attemptId == "") {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "You already attempted this quiz and cannot attempt more than once",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: AppButtonStyle.primaryButton,
                  child: Text(
                    "Kembali",
                    style: AppTextStyle.popins18.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const Scaffold(body: Center(child: Text("Unknown quiz type")));
  }

  Widget buildOptionQuizPage(
    QuizInfo quizInfo,
    final totalQuestions,
  ) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // Card ---------------------------------------------------------
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
                                quizInfo.title,
                                style: AppTextStyle.popins12wBold.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: SvgPicture.asset(
                                      'assets/icons/open_book.svg',
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                  Text(" • "),
                                  Expanded(
                                    child: Text(
                                      (quizInfo.description == null ||
                                              quizInfo.description!
                                                  .trim()
                                                  .isEmpty)
                                          ? "Kuis"
                                          : quizInfo.description!,
                                      style: AppTextStyle.popins10w6.copyWith(
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
                                    quizInfo.answerType == "OPTION"
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/clock.svg',
                                    width: 15,
                                    height: 15,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.black,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    " • ${quizInfo.durationMinutes} menit",
                                    style: AppTextStyle.popins10w6.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),

                                  const Spacer(),

                                  ValueListenableBuilder<Duration>(
                                    valueListenable: remainingTime,
                                    builder: (_, duration, __) {
                                      final mm = duration.inMinutes
                                          .remainder(60)
                                          .toString()
                                          .padLeft(2, '0');
                                      final ss = duration.inSeconds
                                          .remainder(60)
                                          .toString()
                                          .padLeft(2, '0');

                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColor.primaryBlue
                                              .withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Text(
                                          "$mm:$ss",
                                          style: AppTextStyle.inter12.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.primaryBlue,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Question -----------------------------------------------------
                  Flexible(
                    fit: FlexFit.loose,
                    child: PageView.builder(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() => currentIndex = index);
                      },
                      itemCount: questions!.length,
                      itemBuilder: (context, index) {
                        final question = questions![index];
                        final answers = shuffledAnswers[question.questionId]!;
                        final selected = selectedAnswers[question.questionId];

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Card Question ---------------------------------------------------
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Pertanyaan ${index + 1}",
                                      style: AppTextStyle.popins16.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    ToggleButtons(
                                      borderRadius: BorderRadius.circular(12),
                                      fillColor:
                                          markedQuestions[question.questionId]!
                                          ? AppColor.yellow
                                          : Colors.white,
                                      selectedBorderColor: Colors.white,
                                      borderWidth: 2,
                                      borderColor: AppColor.yellow,
                                      selectedColor: AppColor.yellow,
                                      constraints: const BoxConstraints(
                                        minHeight: 40,
                                        minWidth: 40,
                                      ),
                                      isSelected: [
                                        markedQuestions[question.questionId]!,
                                      ],
                                      onPressed: (i) {
                                        final id = question.questionId;
                                        setState(() {
                                          markedQuestions[id] =
                                              !markedQuestions[id]!;
                                        });
                                      },
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Tandai Soal",
                                                style: AppTextStyle
                                                    .popins12wBold
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          markedQuestions[question
                                                              .questionId]!
                                                          ? Colors.white
                                                          : AppColor.yellow,
                                                    ),
                                              ),
                                              const SizedBox(width: 5),
                                              Icon(
                                                markedQuestions[question
                                                        .questionId]!
                                                    ? Icons
                                                          .check_circle_outline_outlined
                                                    : Icons
                                                          .check_circle_rounded,
                                                color:
                                                    markedQuestions[question
                                                        .questionId]!
                                                    ? Colors.white
                                                    : AppColor.yellow,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Pertanyaan",
                                  style: AppTextStyle.popins14.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey.shade100,
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    question.questionText,
                                    style: AppTextStyle.popins14.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  (quizInfo.answerType == "OPTION")
                                      ? "Answer Options"
                                      : "Answer",
                                  style: AppTextStyle.popins14.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (quizInfo.answerType == "OPTION")
                                  RadioGroup<String>(
                                    groupValue: selected,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAnswers[question.questionId] =
                                            value!;
                                      });
                                    },
                                    child: Column(
                                      children: answers.map((answer) {
                                        final isSelected =
                                            selected == answer.answerId;
                                        return GestureDetector(
                                          onTap: () async {
                                            await QuizQuestionService()
                                                .saveAnswerOption(
                                                  token!,
                                                  attemptId!,
                                                  question.questionId,
                                                  answer.answerId,
                                                );
                                            if (!mounted) return;
                                            setState(() {
                                              selectedAnswers[question
                                                      .questionId] =
                                                  answer.answerId;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: isSelected
                                                    ? Colors.grey.shade300
                                                    : Colors.grey.shade200,
                                                width: isSelected ? 3 : 2,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Radio<String>(
                                                  value: answer.answerId,
                                                  activeColor:
                                                      AppColor.primaryBlue,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    answer.answerText,
                                                    style: AppTextStyle.popins14
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                else
                                  TextField(
                                    onChanged: (value) {
                                      selectedAnswers[question.questionId] =
                                          value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Masukkan jawaban...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: currentIndex > 0 ? _prevQuestion : null,
                          style: AppButtonStyle.nextPrev,
                          child: Center(
                            child: Icon(
                              Icons.chevron_left_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: currentIndex < totalQuestions - 1
                              ? _nextQuestion
                              : null,
                          style: AppButtonStyle.nextPrev,
                          child: Center(
                            child: Icon(
                              Icons.chevron_right_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isExpanded)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isExpanded ? 1 : 0,
              child: GestureDetector(
                onTap: () => setState(() => isExpanded = false),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(color: Colors.black.withValues(alpha: 0.1)),
                ),
              ),
            ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: MediaQuery.of(context).size.height / 2 - 25,
            right: isExpanded ? MediaQuery.of(context).size.width * 3 / 5 : 0,
            child: GestureDetector(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                // === Rotating Arrow ===
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  turns: isExpanded ? 0.5 : 0.0,
                  child: const Icon(
                    Icons.chevron_left_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            right: isExpanded ? 0 : -MediaQuery.of(context).size.width * 3 / 5,
            top: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: MediaQuery.of(context).size.width * 3 / 5,
              decoration: BoxDecoration(color: Colors.white),
              child: ClipRect(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  opacity: isExpanded ? 1 : 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/Primary-Logo.png',
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // ==== Navigasi Soal ====---------------------------------------------------------------
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade100,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Navigasi Soal",
                                style: AppTextStyle.popins16.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),

                              Wrap(
                                spacing: 15,
                                runSpacing: 15,
                                children: List.generate(questions!.length, (
                                  index,
                                ) {
                                  final qId = questions![index].questionId;
                                  final bool answered = isQuestionAnswered(qId);
                                  final bool marked = isQuestionMarked(qId);

                                  Color bgColor;
                                  Color textColor;

                                  if (marked) {
                                    bgColor = AppColor.yellow;
                                    textColor = Colors.white;
                                  } else if (answered) {
                                    bgColor = AppColor.primaryBlue;
                                    textColor = Colors.white;
                                  } else {
                                    bgColor = Colors.white;
                                    textColor = AppColor.primaryBlue;
                                  }

                                  return GestureDetector(
                                    onTap: () {
                                      pageController.animateToPage(
                                        index,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                      setState(() {
                                        currentIndex = index;
                                        isExpanded = false;
                                      });
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: marked
                                              ? AppColor.yellow
                                              : AppColor.primaryBlue,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${index + 1}",
                                          style: AppTextStyle.inter14.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),

                              const SizedBox(height: 20),

                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await QuizQuestionService().submitQuiz(
                                      token!,
                                      attemptId!,
                                    );

                                    if (!mounted) return;

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SectionPage(
                                          courseID: widget.courseID,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primaryBlue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    "Selesai",
                                    style: AppTextStyle.popins12wBold.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEssayQuizPage(
    QuizInfo quizInfo,
    final totalQuestions
  ){
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // Card ---------------------------------------------------------
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
                                quizInfo.title,
                                style: AppTextStyle.popins12wBold.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: SvgPicture.asset(
                                      'assets/icons/open_book.svg',
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                  Text(" • "),
                                  Expanded(
                                    child: Text(
                                      (quizInfo.description == null ||
                                              quizInfo.description!
                                                  .trim()
                                                  .isEmpty)
                                          ? "Kuis"
                                          : quizInfo.description!,
                                      style: AppTextStyle.popins10w6.copyWith(
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
                                    quizInfo.answerType == "OPTION"
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/clock.svg',
                                    width: 15,
                                    height: 15,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.black,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    " • ${quizInfo.durationMinutes} menit",
                                    style: AppTextStyle.popins10w6.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),

                                  const Spacer(),

                                  ValueListenableBuilder<Duration>(
                                    valueListenable: remainingTime,
                                    builder: (_, duration, __) {
                                      final mm = duration.inMinutes
                                          .remainder(60)
                                          .toString()
                                          .padLeft(2, '0');
                                      final ss = duration.inSeconds
                                          .remainder(60)
                                          .toString()
                                          .padLeft(2, '0');

                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColor.primaryBlue
                                              .withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Text(
                                          "$mm:$ss",
                                          style: AppTextStyle.inter12.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.primaryBlue,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Question -----------------------------------------------------
                  Flexible(
                    fit: FlexFit.loose,
                    child: PageView.builder(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() => currentIndex = index);
                      },
                      itemCount: questionEssay!.length,
                      itemBuilder: (context, index) {
                        final question = questionEssay![index];
                        final answers = shuffledAnswers[question.questionId]!;
                        final selected = selectedAnswers[question.questionId];

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Card Question ---------------------------------------------------
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Pertanyaan ${index + 1}",
                                      style: AppTextStyle.popins16.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    ToggleButtons(
                                      borderRadius: BorderRadius.circular(12),
                                      fillColor:
                                          markedQuestions[question.questionId]!
                                          ? AppColor.yellow
                                          : Colors.white,
                                      selectedBorderColor: Colors.white,
                                      borderWidth: 2,
                                      borderColor: AppColor.yellow,
                                      selectedColor: AppColor.yellow,
                                      constraints: const BoxConstraints(
                                        minHeight: 40,
                                        minWidth: 40,
                                      ),
                                      isSelected: [
                                        markedQuestions[question.questionId]!,
                                      ],
                                      onPressed: (i) {
                                        final id = question.questionId;
                                        setState(() {
                                          markedQuestions[id] =
                                              !markedQuestions[id]!;
                                        });
                                      },
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Tandai Soal",
                                                style: AppTextStyle
                                                    .popins12wBold
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          markedQuestions[question
                                                              .questionId]!
                                                          ? Colors.white
                                                          : AppColor.yellow,
                                                    ),
                                              ),
                                              const SizedBox(width: 5),
                                              Icon(
                                                markedQuestions[question
                                                        .questionId]!
                                                    ? Icons
                                                          .check_circle_outline_outlined
                                                    : Icons
                                                          .check_circle_rounded,
                                                color:
                                                    markedQuestions[question
                                                        .questionId]!
                                                    ? Colors.white
                                                    : AppColor.yellow,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Pertanyaan",
                                  style: AppTextStyle.popins14.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey.shade100,
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    question.questionText,
                                    style: AppTextStyle.popins14.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  (quizInfo.answerType == "OPTION")
                                      ? "Answer Options"
                                      : "Answer",
                                  style: AppTextStyle.popins14.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (quizInfo.answerType == "OPTION")
                                  RadioGroup<String>(
                                    groupValue: selected,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAnswers[question.questionId] =
                                            value!;
                                      });
                                    },
                                    child: Column(
                                      children: answers.map((answer) {
                                        final isSelected =
                                            selected == answer.answerId;
                                        return GestureDetector(
                                          onTap: () async {
                                            await QuizQuestionService()
                                                .saveAnswerOption(
                                                  token!,
                                                  attemptId!,
                                                  question.questionId,
                                                  answer.answerId,
                                                );
                                            if (!mounted) return;
                                            setState(() {
                                              selectedAnswers[question
                                                      .questionId] =
                                                  answer.answerId;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: isSelected
                                                    ? Colors.grey.shade300
                                                    : Colors.grey.shade200,
                                                width: isSelected ? 3 : 2,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Radio<String>(
                                                  value: answer.answerId,
                                                  activeColor:
                                                      AppColor.primaryBlue,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    answer.answerText,
                                                    style: AppTextStyle.popins14
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                else
                                  TextField(
                                    onChanged: (value) {
                                      selectedAnswers[question.questionId] =
                                          value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Masukkan jawaban...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: currentIndex > 0 ? _prevQuestion : null,
                          style: AppButtonStyle.nextPrev,
                          child: Center(
                            child: Icon(
                              Icons.chevron_left_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: currentIndex < totalQuestions - 1
                              ? _nextQuestion
                              : null,
                          style: AppButtonStyle.nextPrev,
                          child: Center(
                            child: Icon(
                              Icons.chevron_right_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isExpanded)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isExpanded ? 1 : 0,
              child: GestureDetector(
                onTap: () => setState(() => isExpanded = false),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(color: Colors.black.withValues(alpha: 0.1)),
                ),
              ),
            ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: MediaQuery.of(context).size.height / 2 - 25,
            right: isExpanded ? MediaQuery.of(context).size.width * 3 / 5 : 0,
            child: GestureDetector(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                // === Rotating Arrow ===
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  turns: isExpanded ? 0.5 : 0.0,
                  child: const Icon(
                    Icons.chevron_left_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            right: isExpanded ? 0 : -MediaQuery.of(context).size.width * 3 / 5,
            top: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: MediaQuery.of(context).size.width * 3 / 5,
              decoration: BoxDecoration(color: Colors.white),
              child: ClipRect(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  opacity: isExpanded ? 1 : 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/Primary-Logo.png',
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // ==== Navigasi Soal ====---------------------------------------------------------------
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade100,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Navigasi Soal",
                                style: AppTextStyle.popins16.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),

                              Wrap(
                                spacing: 15,
                                runSpacing: 15,
                                children: List.generate(questionEssay!.length, (
                                  index,
                                ) {
                                  final qId = questionEssay![index].questionId;
                                  final bool answered = isQuestionAnswered(qId);
                                  final bool marked = isQuestionMarked(qId);

                                  Color bgColor;
                                  Color textColor;

                                  if (marked) {
                                    bgColor = AppColor.yellow;
                                    textColor = Colors.white;
                                  } else if (answered) {
                                    bgColor = AppColor.primaryBlue;
                                    textColor = Colors.white;
                                  } else {
                                    bgColor = Colors.white;
                                    textColor = AppColor.primaryBlue;
                                  }

                                  return GestureDetector(
                                    onTap: () {
                                      pageController.animateToPage(
                                        index,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                      setState(() {
                                        currentIndex = index;
                                        isExpanded = false;
                                      });
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: marked
                                              ? AppColor.yellow
                                              : AppColor.primaryBlue,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${index + 1}",
                                          style: AppTextStyle.inter14.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),

                              const SizedBox(height: 20),

                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await QuizQuestionService().submitQuiz(
                                      token!,
                                      attemptId!,
                                    );

                                    if (!mounted) return;

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SectionPage(
                                          courseID: widget.courseID,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primaryBlue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    "Selesai",
                                    style: AppTextStyle.popins12wBold.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
