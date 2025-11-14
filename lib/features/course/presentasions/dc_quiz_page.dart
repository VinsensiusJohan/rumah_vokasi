import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';

class DcQuizPage extends StatefulWidget {
  const DcQuizPage({super.key});

  @override
  State<DcQuizPage> createState() => _DcQuizPageState();
}

class _DcQuizPageState extends State<DcQuizPage> {
  final List<String> bab = [
    'Teknik Elektro',
    'Mikrokontroler',
    'Pemrograman',
    'Integrasi Cloud',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Sertifikat",
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
      body: Padding(
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
                        Icon(Icons.star, color: AppColor.iconStar, size: 20),
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
                    const SizedBox(height: 8,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: 0.7,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColor.green2,
                              ),
                              minHeight: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${((0.7) * 100).toStringAsFixed(0)}%",
                          style: AppTextStyle.popins12wBold,
                        ),
                      ],
                    ),
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
          ],
        ),
      ),
    );
  }
}
