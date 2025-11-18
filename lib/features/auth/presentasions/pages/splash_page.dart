import 'package:flutter/material.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'dart:math';
import 'dart:async';

import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:flutter/gestures.dart';
import 'package:rumah_vokasi/features/auth/presentasions/pages/eula_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _fallController;
  late AnimationController _scaleupController;
  late AnimationController _moveupController;

  late Animation<double> _fallAnimation;
  late Animation<double> _scaleupAnimation;
  late Animation<double> _moveupAnimation;

  bool _showFall = false;
  bool _showScaleup = false;
  bool _showMoveup = false;

  @override
  void initState() {
    super.initState();

    _fallController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _fallAnimation = CurvedAnimation(
      parent: _fallController,
      curve: const EaseOutElastic(),
    );

    _scaleupController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _scaleupController.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          _moveupController.status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    _scaleupAnimation = Tween(
      begin: 1.0,
      end: 2.0,
    ).chain(CurveTween(curve: const EaseInQuad())).animate(_scaleupController);

    _moveupController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _moveupController.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          _scaleupController.status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    _moveupAnimation = Tween<double>(begin: 0.0, end: -150).animate(
      CurvedAnimation(parent: _moveupController, curve: const EaseInQuad()),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _showFall = true);
    await _fallController.forward();

    await Future.delayed(const Duration(milliseconds: 400));

    setState(() {
      _showScaleup = true;
      _showMoveup = true;
    });

    Future.wait([_scaleupController.forward(), _moveupController.forward()]);
  }

  @override
  void dispose() {
    _fallController.dispose();
    _scaleupController.dispose();
    _moveupController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (_showFall)
            AnimatedBuilder(
              animation: _fallAnimation,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      (screenHeight / 2) * (_fallAnimation.value - 1),
                    ),
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/images/Primary-Logo.png',
                width: 100,
                height: 100,
              ),
            ),

          if (_showScaleup || _showMoveup)
            Positioned.fill(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),

          if (_showScaleup && _showMoveup)
            AnimatedBuilder(
              animation: Listenable.merge([
                _scaleupController,
                _moveupController,
              ]),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _moveupAnimation.value),
                  child: Transform.scale(
                    scale: _scaleupAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Image.asset(
                  'assets/images/Primary-Logo.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),

          if (_scaleupController.isCompleted && _moveupController.isCompleted)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment(
                        0,
                        0.15,
                      ), // 0 = tengah, 0.3 = sedikit di bawah tengah
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Text(
                              'E-Learning Solution for Vocational Education',
                              style: AppTextStyle.default26w9.copyWith(
                                color: AppColor.primaryBlue,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 300,
                            child: Text(
                              'Belajar interaktif berbasis praktik, siap menghadapi dunia kerja.',
                              style: AppTextStyle.popins18.copyWith(
                                color: AppColor.textGrey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EulaPage(),
                        ),
                      );
                    },
                    style: AppButtonStyle.primaryButton,
                    child: Text(
                      'Lanjutkan',
                      style: AppTextStyle.popins18.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                "By logging in or registering, you agree to our ",
                          ),
                          TextSpan(
                            text: "Terms of Service",
                            style: const TextStyle(
                              color: AppColor.primaryBlue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          const TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: const TextStyle(
                              color: AppColor.primaryBlue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          const TextSpan(text: "."),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // sedikit jarak dari bawah layar
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class EaseOutElastic extends Curve {
  const EaseOutElastic();
  @override
  double transform(double t) {
    const c4 = (2 * pi) / 3;
    if (t == 0) return 0;
    if (t == 1) return 1;
    return pow(2, -10 * t) * sin((t * 10 - 0.75) * c4) + 1;
  }
}

class EaseInQuad extends Curve {
  const EaseInQuad();
  @override
  double transform(double t) {
    return t * t;
  }
}
