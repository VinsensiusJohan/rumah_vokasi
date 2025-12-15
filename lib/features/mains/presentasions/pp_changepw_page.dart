import 'package:flutter/material.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_form_style.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/mains/presentasions/home_page.dart';
import 'package:rumah_vokasi/features/mains/services/change_password_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PpChangepwPage extends StatefulWidget {
  const PpChangepwPage({super.key});

  @override
  State<PpChangepwPage> createState() => _PpChangepwPageState();
}

class _PpChangepwPageState extends State<PpChangepwPage> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _obscureOP = true;
  bool _obscureNP = true;
  bool _obscureCP = true;

  String? userID;
  String? token;

  @override
  void initState() {
    super.initState();
    loadUserFromSP();
  }

  Future<void> loadUserFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("access_token");
      userID = prefs.getString("user_id");
    });
  }

  Future<void> updatePassword(
    String userID,
    String oldPassword,
    String newPassword,
    String token,
  ) async {
    try {
      final response = await ChangePasswordService().changeUserPassword(
        userID: userID,
        oldPassword: oldPassword,
        newPassword: newPassword,
        token: token,
      );

      if (response) {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(index: 2)),
        );
      } else {
        debugPrint("Somethings Wrong");
      }
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  Future<void> submitUpdate() async {
    String oldPassword = _oldPassword.text.trim();
    String newPassword = _newPassword.text.trim();
    String confirmPassword = _confirmPassword.text.trim();

    bool isValid = true;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        isValid = false;
      });
    }

    if (newPassword != confirmPassword) {
      setState(() {
        isValid = false;
      });
    }

    if (!isValid) {
      return;
    } else {
      updatePassword(userID!, oldPassword, newPassword, token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Ganti Password",
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
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password Lama",
                  style: AppTextStyle.popins16.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _oldPassword,
                obscureText: _obscureOP,
                obscuringCharacter: '*',
                decoration: AppFormStyle.passwordField(
                  hint: "Password Lama",
                  obscureText: _obscureOP,
                  onToggle: () {
                    setState(() {
                      _obscureOP = !_obscureOP;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password Baru",
                  style: AppTextStyle.popins16.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _newPassword,
                obscureText: _obscureNP,
                obscuringCharacter: '*',
                decoration: AppFormStyle.passwordField(
                  hint: "Password Baru",
                  obscureText: _obscureNP,
                  onToggle: () {
                    setState(() {
                      _obscureNP = !_obscureNP;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Konfirmasi Password",
                  style: AppTextStyle.popins16.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPassword,
                obscureText: _obscureCP,
                obscuringCharacter: '*',
                decoration: AppFormStyle.passwordField(
                  hint: "Konfirmasi Password",
                  obscureText: _obscureCP,
                  onToggle: () {
                    setState(() {
                      _obscureCP = !_obscureCP;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
        child: ElevatedButton(
          style: AppButtonStyle.primaryButton,
          onPressed: () {
            submitUpdate();
          },
          child: Text(
            "Simpan & Ubah",
            style: AppTextStyle.popins18.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
