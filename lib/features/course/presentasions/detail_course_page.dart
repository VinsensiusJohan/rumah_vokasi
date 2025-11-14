import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/course/models/course_section_model.dart';
import 'package:rumah_vokasi/utils/dummy_data.dart';

class DetailCoursePage extends StatefulWidget {
  const DetailCoursePage({super.key});

  @override
  State<DetailCoursePage> createState() => _DetailCoursePageState();
}

class _DetailCoursePageState extends State<DetailCoursePage> {
  final List<String> bab = [
    'Teknik Elektro',
    'Mikrokontroler',
    'Pemrograman',
    'Integrasi Cloud',
  ];

  List<CourseSection> _section = [];

  @override
  void initState() {
    super.initState();
    _section = section;
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/nps/course-1.png',
              width: screenwidth,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 20,
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
              child: ListView(
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
                                  "Budi Santosa",
                                  style: AppTextStyle.popins12wBold.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.textGrey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.star,
                                color: AppColor.iconStar,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '4.3',
                                style: AppTextStyle.popins14.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.textGrey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Pembuatan Dasar Robot",
                            style: AppTextStyle.popins14.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Materi ini untuk pelajar, maupun siapa saja yang ingin meningkatkan pengembangan teknik industri secara profesional.',
                            style: AppTextStyle.popins10w6.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: bab.asMap().entries.map((entry) {
                                final index = entry.key;
                                final babName = entry.value;

                                final colors = [
                                  AppColor.primaryBlue,
                                  AppColor.yellow,
                                  AppColor.green,
                                ];

                                final color = colors[index % colors.length];

                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    babName,
                                    style: AppTextStyle.popins12wBold.copyWith(
                                      color: color,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Material(
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Text(
                              "Deskripsi Kelas",
                              style: AppTextStyle.popins14.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            children: [ListTile(title: Text("data"))],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _section.length,
                    itemBuilder: (context, index) {
                      final sectionData = _section[index];
                      return Card(
                        elevation: 0,
                        margin: EdgeInsets.only(top: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.grey.shade200,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColor.primaryBlue.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                                child: Text(
                                  index + 1 < 10
                                      ? '0${index + 1}'
                                      : '${index + 1}',
                                  style: AppTextStyle.popins16.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.primaryBlue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sectionData.title,
                                    style: AppTextStyle.popins14.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
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
                                      const SizedBox(width: 6),
                                      Text(
                                        '• ${sectionData.total} ${sectionData.type.label}',
                                        style: AppTextStyle.popins10w6.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.textGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Icon(
                                Icons.chevron_right_outlined,
                                size: 18,
                                color: Colors.grey.shade400,
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
        ],
      ),
    );
  }
}
