import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_form_style.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/course/presentasions/section_page.dart';
import 'package:rumah_vokasi/features/mains/models/enrollment_model.dart';
import 'package:rumah_vokasi/features/mains/services/enrollment_course_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HpPacket extends StatefulWidget {
  const HpPacket({super.key});

  @override
  State<HpPacket> createState() => _HpPacketState();
}

class _HpPacketState extends State<HpPacket> {
  final TextEditingController _search = TextEditingController();

  String seletedFilter = 'all';
  int _selectedCategory = 0;
  Set<String> bookmarkID = {};

  String? name;
  String? token;
  String? userId;
  List<EnrollmentItem> enrollment = [];

  bool isLoading = false;

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
    final resultEnrollment = await EnrollmentCourseService().getEnrollment(
      token,
    );
    if (!mounted) return;
    setState(() {
      enrollment = resultEnrollment;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _search.dispose();
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
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text("Kursus Saya", style: AppTextStyle.popins20wBold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _search,
                decoration: AppFormStyle.searchField(
                  icon: Icons.search,
                  hint: 'Cari',
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryButton(
                      0,
                      'assets/icons/triple-box.svg',
                      "Semua",
                      'all',
                    ),
                    const SizedBox(width: 10),
                    _buildCategoryButton(
                      1,
                      'assets/icons/fire.svg',
                      "Progress",
                      'onProgress',
                    ),
                    const SizedBox(width: 10),
                    _buildCategoryButton(
                      2,
                      'assets/icons/trophy.svg',
                      "Selesai",
                      'completed',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Aktivitas Terbaru',
                style: AppTextStyle.popins18.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sabtu, 30 Oktober 2025',
                        style: AppTextStyle.popins12wBold.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Riyawat Pembelajaran',
                style: AppTextStyle.popins18.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: enrollment.length,
                      itemBuilder: (context, index) {
                        final enrollmentShow = enrollment[index];
                        final List<String?> tags = [
                          enrollmentShow.subBagTitle,
                          enrollmentShow.subTitle,
                          enrollmentShow.kompetensiTitle,
                          enrollmentShow.programTitle,
                          enrollmentShow.bidangTitle,
                        ].where((e) => e != null && e.isNotEmpty).toList();
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SectionPage(
                                  courseID: enrollmentShow.courseId,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.only(top: 8, bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 3,
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                        child: enrollmentShow.image.isEmpty
                                            ? Image.asset(
                                                'assets/nps/course-1.png',
                                                width: double.infinity,
                                                height: 150,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.memory(
                                                base64Decode(
                                                  enrollmentShow.image,
                                                ),
                                                width: double.infinity,
                                                height: 150,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 3,
                                            horizontal: 25,
                                          ),
                                          decoration: const BoxDecoration(
                                            color: AppColor.primaryBlue,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              bottomRight: Radius.circular(24),
                                            ),
                                          ),
                                          child: Text(
                                            "Gratis",
                                            style: AppTextStyle.default16w6
                                                .copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 10,
                                        bottom: 10,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.tagBestSeller,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            "Best Seller!",
                                            style: AppTextStyle.popins10w6
                                                .copyWith(
                                                  color:
                                                      AppColor.textBestSeller,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    10,
                                    0,
                                    10,
                                    10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  enrollmentShow.courseTitle,
                                                  style: AppTextStyle.popins18
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  enrollmentShow.instructorName,
                                                  style: AppTextStyle.popins14
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppColor.textGrey,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: tags.asMap().entries.map((
                                            entry,
                                          ) {
                                            final index = entry.key;
                                            final tag = entry.value;

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
                                                tag!,
                                                style: AppTextStyle
                                                    .popins12wBold
                                                    .copyWith(
                                                      color: color,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
    int index,
    String svgAsset,
    String label,
    String value,
  ) {
    final bool isSelected = _selectedCategory == index;

    final List<Color> buttonActiveColor = [
      AppColor.blueButtonPacket,
      AppColor.orangeButtonPacket,
      AppColor.greenButtonPacket,
    ];

    final List<Color> iconActiveColor = [
      AppColor.blueIconPacket,
      AppColor.orangeIconPacket,
      AppColor.greenIconPacket,
    ];

    final List<Color> circleInactiveColor = [
      AppColor.blueButtonPacket,
      AppColor.orangeButtonPacket,
      AppColor.greenButtonPacket,
    ];

    final Color buttonColor = isSelected
        ? buttonActiveColor[index]
        : Colors.white;

    final Color circleColor = isSelected
        ? Colors.white
        : circleInactiveColor[index];

    final Color iconColor = isSelected ? iconActiveColor[index] : Colors.white;

    final Color textColor = isSelected ? Colors.white : Colors.black;

    final Color borderColor = isSelected
        ? buttonActiveColor[index]
        : Colors.grey.shade300;
    return ElevatedButton(
      style: AppButtonStyle.categoryButton.copyWith(
        backgroundColor: WidgetStatePropertyAll(buttonColor),
        side: WidgetStatePropertyAll(BorderSide(color: borderColor)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        ),
      ),
      onPressed: () {
        setState(() {
          _selectedCategory = index;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 8),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor,
            ),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  svgAsset,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          Text(
            label,
            style: AppTextStyle.popins12wBold.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
