import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_form_style.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/mains/models/course_user_model.dart';
import 'package:rumah_vokasi/features/mains/services/bookmark_service.dart';
import 'package:rumah_vokasi/utils/dummy_data.dart';

class HpPacket extends StatefulWidget {
  const HpPacket({super.key});

  @override
  State<HpPacket> createState() => _HpPacketState();
}

class _HpPacketState extends State<HpPacket> {
  final TextEditingController _search = TextEditingController();

  String seletedFilter = 'all';
  int _selectedCategory = 0;
  List<CourseUser> filteredCourse = [];
  Set<String> bookmarkID = {};

  @override
  void dispose() {
    super.dispose();
    _search.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadBookMark();
    filteredCourse = allCourses;
  }

  void applyFilter(String filter) {
    setState(() {
      seletedFilter = filter;

      if (filter == 'onProgress') {
        filteredCourse = allCourses.where((c) => c.progress < 1.0).toList();
      } else if (filter == 'completed') {
        filteredCourse = allCourses.where((c) => c.progress == 1.0).toList();
      } else {
        filteredCourse = allCourses;
      }
    });
  }

  void toggleBookmark(String id) async {
    await BookmarkService.toggleBookmark(id);
    final update = await BookmarkService.getBookMark();
    setState(() {
      bookmarkID = update;
    });
  }

  Future<void> _loadBookMark() async {
    final save = await BookmarkService.getBookMark();
    setState(() {
      bookmarkID = save;
    });
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCourse.length,
                itemBuilder: (context, index) {
                  final packet = filteredCourse[index];
                  final isBookMark = bookmarkID.contains(packet.id);
                  return InkWell(
                    onTap: () {},
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 3,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  ),
                                  child: Image.asset(
                                    packet.image,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: packet.progress == 1.0
                                          ? AppColor.greenButtonPacket
                                          : AppColor.orangeButtonPacket,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                      ),
                                    ),
                                    child: SvgPicture.asset(
                                      packet.progress == 1.0
                                          ? 'assets/icons/trophy.svg'
                                          : 'assets/icons/fire.svg',
                                      width: 17,
                                      height: 17,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          packet.title,
                                          style: AppTextStyle.popins18.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          packet.name,
                                          style: AppTextStyle.popins14.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.textGrey,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      child: IconButton(
                                        icon: Icon(
                                          isBookMark
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                        ),
                                        color: AppColor.primaryBlue,
                                        onPressed: () =>
                                            toggleBookmark(packet.id),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: packet.bab.asMap().entries.map((
                                      entry,
                                    ) {
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
                                        margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          babName,
                                          style: AppTextStyle.popins12wBold
                                              .copyWith(color: color, fontWeight: FontWeight.w500),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: LinearProgressIndicator(
                                          value: packet.progress,
                                          backgroundColor: Colors.grey.shade200,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColor.green2,
                                              ),
                                          minHeight: 10,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "${((packet.progress) * 100).toStringAsFixed(0)}%",
                                      style: AppTextStyle.popins12wBold,
                                    ),
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
          applyFilter(value);
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
