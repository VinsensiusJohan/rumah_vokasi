import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/features/mains/presentasions/hp_beranda.dart';
import 'package:rumah_vokasi/features/mains/presentasions/hp_course.dart';
import 'package:rumah_vokasi/features/mains/presentasions/hp_profile.dart';

class HomePage extends StatefulWidget {
  final int index;
  const HomePage({super.key, required this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indexPages = 0;

  final List<Widget> _pages = const [
    HpBeranda(),
    HpPacket(),
    HpProfile()
  ];

  @override
  void initState() {
    super.initState();
    _indexPages = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indexPages,
        children: _pages,
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [Container(height: 80, color: AppColor.primaryDarkBlue3)],
          ),
          Positioned(
            bottom: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavIcon(
                    'assets/icons/home.svg',
                    'assets/icons/home_outline.svg',
                    _indexPages == 0,
                    onTap: () => setState(() => _indexPages = 0),
                  ),
                  _buildNavIcon(
                    'assets/icons/packet.svg',
                    'assets/icons/packet_outline.svg',
                    _indexPages == 1,
                    onTap: () => setState(() => _indexPages = 1),
                  ),
                  _buildNavIcon(
                    'assets/icons/person.svg',
                    'assets/icons/person_outline.svg',
                    _indexPages == 2,
                    onTap: () => setState(() => _indexPages = 2),
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

Widget _buildNavIcon(String svgPath, String svgPathOutline, bool isSelected, {VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.08),
      ),
      child: isSelected
      ? SvgPicture.asset(
        svgPath,
        height: 26,
        width: 26,
        colorFilter: ColorFilter.mode(AppColor.primaryBlue,
          BlendMode.srcIn,
        ),
      ) : SvgPicture.asset(
        svgPathOutline,
        height: 26,
        width: 26,
        colorFilter: ColorFilter.mode(Colors.white,
          BlendMode.srcIn,
        ),
      ),
    ),
  );
}
