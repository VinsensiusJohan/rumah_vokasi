import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_form_style.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/mains/models/course_model.dart';
import 'package:rumah_vokasi/features/mains/services/bookmark_service.dart';
import 'package:rumah_vokasi/features/mains/services/enrollment_course_service.dart';
import 'package:rumah_vokasi/features/mains/services/user_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HpBeranda extends StatefulWidget {
  const HpBeranda({super.key});

  @override
  State<HpBeranda> createState() => _HpBerandaState();
}

class _HpBerandaState extends State<HpBeranda>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _search = TextEditingController();
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final List<String> imgList = [
    'assets/images/eula-slide-1.png',
    'assets/images/eula-slide-1.png',
    'assets/images/eula-slide-1.png',
  ];

  List<CourseItem> course = [];
  Set<String> bookMarkID = {};
  late List<bool> isBookMarkList;
  List<String> listBookMark = [];

  bool isRefreshing = false;

  final Map<String, MemoryImage> _courseImageMemory = {};

  int _selectedCategory = 0;

  ValueNotifier<int> sliderIndex = ValueNotifier(0);
  late ValueNotifier<Set<String>> bookmarkNotifier;

  String? name;
  String? token;
  String? userId;
  String? image;

  bool isLoading = false;

  MemoryImage? profileImage;

  Future<void> preloadCourseImage() async {
    for (final c in course) {
      if (c.image.isEmpty) continue;

      if (_courseImageMemory.containsKey(c.id)) continue;

      try {
        final bytes = base64Decode(c.image);
        _courseImageMemory[c.id] = MemoryImage(bytes);
      } catch (_) {}
    }
  }

  Future<void> loadUserFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    final nameSP = prefs.getString("name");
    final tokenSP = prefs.getString("access_token");
    final userIdSP = prefs.getString("user_id");
    if (tokenSP == null || userIdSP == null) return;

    final resultProfile = await UserProfileService().getProfile(
      tokenSP,
      userIdSP,
    );

    if (resultProfile?.profilePicture != null) {
      profileImage = MemoryImage(base64Decode(resultProfile!.profilePicture!));
    }

    await loadData(tokenSP, userIdSP);
    await preloadCourseImage();
    if (!mounted) return;
    setState(() {
      name = nameSP;
      token = tokenSP;
      userId = userIdSP;
      image = resultProfile?.profilePicture;
    });

    if (image != null) {
      await prefs.setString("profile_photo", image!);
    }
  }

  Future<void> loadData(String token, String userId) async {
    final prefs = await SharedPreferences.getInstance();

    // 1️⃣ Load cache dulu (CEPAT)
    final cachedCourse = prefs.getString('cache_courses');
    if (cachedCourse != null) {
      final decoded = jsonDecode(cachedCourse) as List;
      course = decoded.map((e) => CourseItem.fromJson(e)).toList();
      setState(() {}); // tampilkan langsung
    }

    // 2️⃣ Hit API (VALIDASI)
    final resultCourse = await EnrollmentCourseService().getCourse(token);
    final resultBookmark = await BookmarkService().getUserBookmarks(
      token,
      userId,
    );

    // 3️⃣ Update cache jika berubah
    listBookMark = resultBookmark;
    if (jsonEncode(course) != jsonEncode(resultCourse)) {
      course = resultCourse;

      prefs.setString(
        'cache_courses',
        jsonEncode(resultCourse.map((e) => e.toJson()).toList()),
      );
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
      isRefreshing = false;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadUserFromSP();
    bookmarkNotifier = ValueNotifier<Set<String>>(listBookMark.toSet());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  isRefreshing = true;
                  await loadData(token!, userId!);
                  await preloadCourseImage();
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: headerWidget()),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final courseShow = course[index];
                        return courseItem(
                          courseShow,
                          bookmarkNotifier,
                          _courseImageMemory,
                          token!,
                          userId!,
                        );
                      }, childCount: course.length),
                    ),
                  ],
                ),
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

  Widget headerWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                  image: DecorationImage(
                    image: image == null
                        ? const AssetImage('assets/images/eula-slide-1.png')
                        : profileImage!,
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
                sliderIndex.value = index;
              },
            ),
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder(
            valueListenable: sliderIndex,
            builder: (context, value, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _carouselController.animateToPage(entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: sliderIndex.value == entry.key ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: sliderIndex.value == entry.key
                            ? AppColor.primaryDarkBlue2
                            : Colors.grey.withValues(alpha: 0.4),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
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
                _buildCategoryButton(2, 'assets/icons/trophy.svg', "Advanced"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Kategori',
            style: AppTextStyle.popins18.copyWith(fontWeight: FontWeight.bold),
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
            style: AppTextStyle.popins18.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

Widget courseItem(
  CourseItem courseShow,
  ValueNotifier<Set<String>> bookmarkNotifier,
  Map<String, MemoryImage> courseImageMemory,
  String token,
  String userId,
) {
  final List<String?> tags = [
    courseShow.subBagTitle,
    courseShow.subTitle,
    courseShow.kompetensiTitle,
    courseShow.programTitle,
    courseShow.bidangTitle,
  ].where((e) => e != null && e.isNotEmpty).toList();
  return Card(
    margin: EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 3,
    child: Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image(
            image:
                courseImageMemory[courseShow.id] ??
                const AssetImage('assets/nps/course-1.png'),
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          courseShow.title,
                          style: AppTextStyle.popins18.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          courseShow.instructorName,
                          style: AppTextStyle.popins14.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColor.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: bookmarkNotifier,
                    builder: (context, bookmarks, _) {
                      final isBookmarked = bookmarks.contains(courseShow.id);

                      return IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        ),
                        color: AppColor.primaryBlue,
                        onPressed: () async {
                          if (isBookmarked) {
                            await BookmarkService().removeBookmark(
                              token,
                              courseShow.id,
                              userId,
                            );

                            // update notifier tanpa rebuild widget lain
                            bookmarkNotifier.value = {
                              ...bookmarks..remove(courseShow.id),
                            };
                          } else {
                            await BookmarkService().addBookmark(
                              token,
                              courseShow.id,
                            );

                            bookmarkNotifier.value = {
                              ...bookmarks..add(courseShow.id),
                            };
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: tags.asMap().entries.map((entry) {
                    final index = entry.key;
                    final tag = entry.value;

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
                        tag!,
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
      ],
    ),
  );
}
