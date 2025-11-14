import 'package:flutter/material.dart';
import 'package:rumah_vokasi/core/app_color.dart';

class AppButtonStyle {
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColor.primaryBlue,
    foregroundColor: Colors.white,
    minimumSize: Size(350, 50),
    maximumSize: Size(400, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    shadowColor: Colors.transparent,
    elevation: 0,
  );

  static final ButtonStyle categoryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColor.primaryBlue,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    elevation: 0,
    alignment: Alignment.centerLeft,
    maximumSize: Size(120, 50),
  );

  static final ButtonStyle nextPrev = ElevatedButton.styleFrom(
    backgroundColor: AppColor.primaryBlue,
    minimumSize: Size(40, 40),
    maximumSize: Size(50, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: EdgeInsets.zero,
  );
}
