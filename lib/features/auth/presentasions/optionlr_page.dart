import 'package:flutter/material.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/auth/presentasions/login_register_page.dart';

class OptionlrPage extends StatelessWidget {
  const OptionlrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

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
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: screenheight / 2 - 370,
              left: screenwidth / 2 - 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      color: AppColor.primaryBlue.withValues(alpha: 0.5),
                    ),
                  ),
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(125),
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    child: Image.asset(
                      'assets/images/eula-slide-4.png',
                      width: 280,
                      height: 280,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Align(
                        alignment: const Alignment(0, 0.6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Nikmati Aktifitas Pembelajaran dengan Guru Terbaik',
                              style: AppTextStyle.popins24w9,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Wujudkan karier terarah dengan keterampilan vokasi yang relevan.",
                              style: AppTextStyle.popins18.copyWith(
                                color: AppColor.textGrey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: AppButtonStyle.primaryButton,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginRegisterPage(initialLogin: false),
                        ),
                      );
                    },
                    child: Text("Buat Akun", style: AppTextStyle.popins18),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: AppButtonStyle.primaryButton.copyWith(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginRegisterPage(initialLogin: true),
                        ),
                      );
                    },
                    child: Text(
                      "Masuk",
                      style: AppTextStyle.popins18.copyWith(
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
}
