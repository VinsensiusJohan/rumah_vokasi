import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_form_style.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/mains/models/enrollment_model.dart';
//import 'package:rumah_vokasi/features/mains/services/enrollment_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HpBeranda extends StatefulWidget {
  const HpBeranda({super.key});

  @override
  State<HpBeranda> createState() => _HpBerandaState();
}

class _HpBerandaState extends State<HpBeranda> {
  final TextEditingController _search = TextEditingController();
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final List<String> imgList = [
    'assets/images/eula-slide-1.png',
    'assets/images/eula-slide-1.png',
    'assets/images/eula-slide-1.png',
  ];

  List<EnrollmentItem> enrollment = [];

  int _currentIndex = 0;
  int _selectedCategory = 0;

  late List<bool> isBookMarkList;

  String? name;
  String? token;

  Future<void> loadUserFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name");
      token = prefs.getString("access_token");
    });
    //if (token != null) {
    //  loadData(token!);
    //}
  }

  //Future<void> loadData(String token) async {
  //  final result = await EnrollmentService().getEnrollment(token);
  //  setState(() {
  //    enrollment = result;
  //    isBookMarkList = List.generate(enrollment.length, (_) => false);
  //  });
  //}

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadUserFromSP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Halo",
                              style: AppTextStyle.popins14.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              name ?? "",
                              style: AppTextStyle.popins20wBold.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/eula-slide-1.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    child: TextFormField(
                      controller: _search,
                      decoration: AppFormStyle.searchField(
                        icon: Icons.search,
                        hint: 'Mulai cari paket Anda!',
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  CarouselSlider(
                    items: imgList.map((url) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      height: 130,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      enlargeCenterPage: false,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() => _currentIndex = index);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imgList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () =>
                            _carouselController.animateToPage(entry.key),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: _currentIndex == entry.key ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _currentIndex == entry.key
                                ? AppColor.primaryDarkBlue2
                                : Colors.grey.withValues(alpha: 0.4),
                          ),
                        ),
                      );
                    }).toList(),
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
                          'assets/icons/rocket-launch.svg',
                          "Trending",
                        ),
                        const SizedBox(width: 8),
                        _buildCategoryButton(
                          1,
                          'assets/icons/triple-star.svg',
                          "Terbaru",
                        ),
                        const SizedBox(width: 8),
                        _buildCategoryButton(
                          2,
                          'assets/icons/trophy.svg',
                          "Advanced",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Kategori',
                    style: AppTextStyle.popins18.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCategory(
                          'assets/images/robotic.png',
                          'Teknologi & Rekayasa',
                        ),
                        _buildCategory(
                          'assets/images/programming.png',
                          'Informasi & Komunikasi',
                        ),
                        _buildCategory(
                          'assets/images/robotic.png',
                          'Teknologi & Rekayasa',
                        ),
                        _buildCategory(
                          'assets/images/programming.png',
                          'Informasi & Komunikasi',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kursus Gratis',
                    style: AppTextStyle.popins18.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Center(
                    child: Text(
                      "Belum ada Enrollment",
                      style: AppTextStyle.default16w6.copyWith(
                        color: AppColor.primaryBlue,
                      ),
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

  Widget _buildCategoryButton(int index, String svgAssets, String label) {
    final bool isSelected = _selectedCategory == index;

    return ElevatedButton(
      style: AppButtonStyle.categoryButton.copyWith(
        backgroundColor: WidgetStatePropertyAll(
          isSelected ? AppColor.primaryDarkBlue : Colors.white,
        ),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: isSelected ? AppColor.primaryDarkBlue : Colors.grey.shade300,
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        ),
      ),

      onPressed: () {
        setState(() {
          _selectedCategory = index;
        });
      },

      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.white
                      : AppColor.primaryBlue.withValues(alpha: 0.4),
                ),
              ),
              Text(
                label,
                style: AppTextStyle.popins12wBold.copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          Positioned(
            top: -2,
            left: 6,
            child: SvgPicture.asset(
              svgAssets,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected
                    ? AppColor.primaryBlue.withGreen(125)
                    : AppColor.primaryBlue,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String imgAssets, String text) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 140,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        //color: AppColor.primaryDarkBlue2.withValues(alpha: 0.15)
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            top: 50,
            left: -55,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(125),
                color: AppColor.primaryBlue.withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 20,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(imgAssets),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5, left: 10),
            margin: EdgeInsets.only(top: 70),
            height: 30,
            width: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              color: Colors.white.withValues(alpha: 0.6),
            ),
            child: Text(
              text,
              style: AppTextStyle.popins10w6.copyWith(
                color: AppColor.primaryDarkBlue3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
