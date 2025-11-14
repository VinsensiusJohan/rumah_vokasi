import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/auth/presentasions/optionlr_page.dart';

class EulaPage extends StatefulWidget {
  const EulaPage({super.key});

  @override
  State<EulaPage> createState() => _EulaPageState();
}

class _EulaPageState extends State<EulaPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> slideList = [
    {
      'image': 'assets/images/eula-slide-1.png',
      'vector': 'assets/images/vector-1.svg',
      'title': 'Edukasi',
      'desc':
          'Belajar interaktif berbasis praktik, siap menghadapi dunia kerja.',
    },
    {
      'image': 'assets/images/eula-slide-2.png',
      'vector': 'assets/images/vector-2.svg',
      'title': 'Sertifikasi',
      'desc':
          'Bukti resmi kompetensi diri, meningkatkan kepercayaan dan peluang karier.',
    },
    {
      'image': 'assets/images/eula-slide-3.png',
      'vector': 'assets/images/vector-3.svg',
      'title': 'Gratis',
      'desc':
          'Dapatkan materi dan guru terbaik tanpa dipungut biaya sama sekali',
    },
  ];

  void _onNext() {
    if (_currentPage < slideList.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OptionlrPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 25),
          child: Image.asset('assets/images/Primary-Logo.png', height: 50),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left, color: AppColor.primaryBlue),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slideList.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final slide = slideList[index];
                  return SizedBox(
                    height: screenwidth,
                    width: screenwidth,
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          slide['vector']!,
                          width: screenwidth,
                          height: screenwidth,
                        ),
                        Positioned(
                          left: screenwidth / 2 - 150,
                          top: screenwidth / 2 - 80,
                          child: Image.asset(
                            slide['image']!,
                            width: 300,
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top:
                              MediaQuery.of(context).size.height *
                              0.52, 
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Text(
                                slide['title']!,
                                style: AppTextStyle.popins28w9,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  slide['desc']!,
                                  style: AppTextStyle.popins18.copyWith(
                                    color: AppColor.textGrey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slideList.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: _currentPage == index ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColor.primaryBlue
                        : AppColor.textGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: AppButtonStyle.primaryButton,
              onPressed: _onNext,
              child: Text("Lanjutkan", style: AppTextStyle.popins18),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: AppButtonStyle.primaryButton.copyWith(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OptionlrPage()),
                );
              },
              child: Text(
                "Lewati",
                style: AppTextStyle.popins18.copyWith(
                  color: AppColor.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
