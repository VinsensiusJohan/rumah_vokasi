import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';

class QuizWorkPage extends StatefulWidget {
  const QuizWorkPage({super.key});

  @override
  State<QuizWorkPage> createState() => _QuizWorkPageState();
}

class _QuizWorkPageState extends State<QuizWorkPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> questions = [
    {
      "question_id": "q1",
      "question_text": "Tipe data apa yang digunakan untuk menyimpan teks?",
      "answers": [
        {"answer_id": "a1", "answer_text": "String", "is_correct": 1},
        {"answer_id": "a2", "answer_text": "Int", "is_correct": 0},
        {"answer_id": "a3", "answer_text": "Double", "is_correct": 0},
        {"answer_id": "a4", "answer_text": "Bool", "is_correct": 0},
      ],
    },
    {
      "question_id": "q2",
      "question_text":
          "Simbol apa yang digunakan untuk menandai komentar satu baris di Dart?",
      "answers": [
        {"answer_id": "a5", "answer_text": "//", "is_correct": 1},
        {"answer_id": "a6", "answer_text": "#", "is_correct": 0},
        {"answer_id": "a7", "answer_text": "<!-- -->", "is_correct": 0},
        {"answer_id": "a8", "answer_text": "/* */", "is_correct": 0},
      ],
    },
    {
      "question_id": "q3",
      "question_text":
          "Keyword apa yang digunakan untuk mendefinisikan variabel yang tidak bisa diubah nilainya?",
      "answers": [
        {"answer_id": "a9", "answer_text": "final", "is_correct": 1},
        {"answer_id": "a10", "answer_text": "var", "is_correct": 0},
        {"answer_id": "a11", "answer_text": "dynamic", "is_correct": 0},
        {"answer_id": "a12", "answer_text": "mutable", "is_correct": 0},
      ],
    },
    {
      "question_id": "q4",
      "question_text": "Fungsi utama dari widget `Scaffold` di Flutter adalah?",
      "answers": [
        {
          "answer_id": "a13",
          "answer_text": "Sebagai struktur dasar layout halaman",
          "is_correct": 1,
        },
        {
          "answer_id": "a14",
          "answer_text": "Untuk menampilkan teks",
          "is_correct": 0,
        },
        {
          "answer_id": "a15",
          "answer_text": "Untuk menyimpan data",
          "is_correct": 0,
        },
        {
          "answer_id": "a16",
          "answer_text": "Untuk menambahkan animasi",
          "is_correct": 0,
        },
      ],
    },
  ];

  late final Map<String, List<Map<String, dynamic>>> shuffledAnswers;
  final Map<String, String> selectedAnswers = {};
  Map<String, bool> markedQuestions = {};
  bool isExpanded = false;

  bool isQuestionAnswered(String questionId) {
    return selectedAnswers[questionId] != null; // sudah pilih jawaban
  }

  bool isQuestionMarked(String questionId) {
    return markedQuestions[questionId] == true; // ditandai
  }

  @override
  void initState() {
    super.initState();
    shuffledAnswers = {
      for (var q in questions)
        q["question_id"]: List<Map<String, dynamic>>.from(q["answers"])
          ..shuffle(Random(q["question_id"].hashCode)),
    };

    for (var q in questions) {
      markedQuestions[q["question_id"]] = false;
    }
  }

  void _nextQuestion() {
    if (_currentIndex < questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevQuestion() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalQuestions = questions.length;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "04 - Kuis Akhir Pemrograman",
                              style: AppTextStyle.popins12wBold.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
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
                                Text(
                                  " • Kelas Pemrograman Robotic",
                                  style: AppTextStyle.popins10w6.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  " • Pilihan Ganda",
                                  style: AppTextStyle.popins10w6.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                Text(
                                  " • 50 Soal",
                                  style: AppTextStyle.popins10w6.copyWith(
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
                                  " • 90 Menit",
                                  style: AppTextStyle.popins10w6.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Flexible(
                    fit: FlexFit.loose,
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() => _currentIndex = index);
                      },
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        final answers =
                            shuffledAnswers[question["question_id"]]!;
                        final selected =
                            selectedAnswers[question["question_id"]];

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
                                          markedQuestions[question["question_id"]]!
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
                                        markedQuestions[question["question_id"]]!,
                                      ],
                                      onPressed: (i) {
                                        final id = question["question_id"];
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
                                                          markedQuestions[question["question_id"]]!
                                                          ? Colors.white
                                                          : AppColor.yellow,
                                                    ),
                                              ),
                                              const SizedBox(width: 5),
                                              Icon(
                                                markedQuestions[question["question_id"]]!
                                                    ? Icons
                                                          .check_circle_outline_outlined
                                                    : Icons
                                                          .check_circle_rounded,
                                                color:
                                                    markedQuestions[question["question_id"]]!
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
                                    question["question_text"],
                                    style: AppTextStyle.popins14.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Answer Options",
                                  style: AppTextStyle.popins14.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                RadioGroup<String>(
                                  groupValue: selected,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswers[question["question_id"]] =
                                          value!;
                                    });
                                  },
                                  child: Column(
                                    children: answers.map((answer) {
                                      final answerId =
                                          answer["answer_id"] as String;
                                      final answerText =
                                          answer["answer_text"] as String;
                                      final isSelected = selected == answerId;

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedAnswers[question["question_id"]] =
                                                answerId;
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                                                value: answerId,
                                                activeColor:
                                                    AppColor.primaryBlue,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  answerText,
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
                          onPressed: _currentIndex > 0 ? _prevQuestion : null,
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
                          onPressed: _currentIndex < totalQuestions - 1
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

                        // ==== Navigasi Soal ====
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
                                children: List.generate(questions.length, (
                                  index,
                                ) {
                                  final qId = questions[index]["question_id"];

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
                                      _pageController.animateToPage(
                                        index,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                      setState(() {
                                        _currentIndex = index;
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
                                  onPressed: () {},
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
