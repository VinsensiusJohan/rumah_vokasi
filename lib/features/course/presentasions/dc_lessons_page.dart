import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/utils/dummy_data.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DcLessonsPage extends StatefulWidget {
  const DcLessonsPage({super.key});

  @override
  State<DcLessonsPage> createState() => _DcLessonsPageState();
}

class _DcLessonsPageState extends State<DcLessonsPage> {
  late YoutubePlayerController _controller;
  final String videoUrl = 'https://www.youtube.com/watch?v=7TsgXbRGOQo';
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(videoUrl)!;

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
        isLive: false,
        forceHD: true,
        hideControls: false,
        controlsVisibleAtStart: true,
      ),
    );

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
              onReady: () => debugPrint('Player is ready.'),
            ),
            builder: (context, player) {
              return DefaultTabController(
                length: 3,
                child: Scaffold(
                  backgroundColor: Colors.grey.shade50,
                  body: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      player,
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pembuatan Dasar Robot",
                                  style: AppTextStyle.popins16.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Eulogius Kurdeo Hesay S.Kom.",
                                  style: AppTextStyle.popins12wBold.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.textGrey,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            SvgPicture.asset(
                              'assets/icons/like.svg',
                              width: 30,
                              height: 30,
                              colorFilter: const ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 25),
                            SvgPicture.asset(
                              'assets/icons/dislike.svg',
                              width: 30,
                              height: 30,
                              colorFilter: const ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- Section Lanjutkan Pembelajaran
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 10,
                          bottom: 5,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Lanjutkan Pembelajaran",
                            style: AppTextStyle.popins16.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        clipBehavior: Clip.none,
                        child: Row(
                          children: optLesson.map((item) {
                            return Container(
                              width: 200,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.asset(
                                      item.image,
                                      width: 200,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
                                              style: AppTextStyle.popins14
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            Text(
                                              "Lanjutkan Materi Pembelajaran",
                                              style: AppTextStyle.popins10w6
                                                  .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        SvgPicture.asset(
                                          'assets/icons/play.svg',
                                          height: 20,
                                          width: 20,
                                          colorFilter: ColorFilter.mode(
                                            Colors.black,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // --- Section TabBar Deskripsi, QnA, Review
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 3,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: 5 / 6,
                                child: TabBar(
                                  labelColor: Colors.black,
                                  unselectedLabelColor: Colors.grey.shade800,
                                  indicatorColor: AppColor.yellow,
                                  labelStyle: AppTextStyle.popins14.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  unselectedLabelStyle: AppTextStyle
                                      .popins12wBold
                                      .copyWith(fontWeight: FontWeight.w400),
                                  tabs: const [
                                    Tab(text: "Deskripsi"),
                                    Tab(text: "QnA"),
                                    Tab(text: "Review"),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 250,
                              child: TabBarView(
                                children: [
                                  // Tab Deskripsi
                                  SingleChildScrollView(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      "Deskripsi lengkap pembelajaran robot dasar.\n\n"
                                      "Dalam sesi ini kamu akan mempelajari struktur dasar dari robotika, "
                                      "termasuk sensor, aktuator, dan pengendalian sederhana menggunakan mikrokontroler.",
                                      style: AppTextStyle.popins14,
                                    ),
                                  ),
                                  const Center(
                                    child: Text("Belum ada pertanyaan."),
                                  ),
                                  const Center(
                                    child: Text("Belum ada ulasan."),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),

          Positioned(
            top: 10,
            left: 10,
            child: IgnorePointer(
              ignoring: _isPlaying,
              child: Opacity(
                opacity: _isPlaying ? 0 : 1,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.chevron_left_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
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
