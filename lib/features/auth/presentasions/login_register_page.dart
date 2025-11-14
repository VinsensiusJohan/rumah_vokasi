import 'package:flutter/material.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_form_style.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/mains/presentasions/home_page.dart';

class LoginRegisterPage extends StatefulWidget {
  final bool initialLogin;
  const LoginRegisterPage({super.key, this.initialLogin = true});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nama = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool isLogin = true;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    isLogin = widget.initialLogin;
  }

  void toggleForm() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nama.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    //final screenheight = MediaQuery.of(context).size.height;

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
              top: isLogin ? 200 : 150,
              left: isLogin ? -150 : -300,
              child: Container(
                height: isLogin ? 700 : 1000,
                width: isLogin ? 700 : 1000,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isLogin ? 350 : 500),
                  color: AppColor.primaryBlue.withValues(alpha: 0.2),
                ),
              ),
            ),
            Positioned(
              left: isLogin ? (screenwidth / 2 - 100) : (screenwidth / 2 - 75),
              top: isLogin ? 80 : 50,
              child: Image.asset(
                'assets/images/login-register.png',
                width: isLogin ? 200 : 150,
                height: isLogin ? 200 : 150,
              ),
            ),
            Transform.translate(
              offset: Offset(0, 5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLogin ? 'Selamat Datang!' : "Daftarkan Diri Anda!",
                      style: AppTextStyle.popins28w9.copyWith(
                        color: AppColor.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isLogin
                          ? "“Masuk dan lanjutkan perjalanan belajarmu bersama Rumah Vokasi!”"
                          : "“Daftarkan dirimu sekarang, kembangkan keterampilan, dan raih masa depan cerah!”",
                      style: AppTextStyle.popins18.copyWith(
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              if (!isLogin) ...[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Nama",
                                    style: AppTextStyle.default16w6,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _nama,
                                  decoration: AppFormStyle.textField(
                                    icon: Icons.person,
                                    hint: 'Nama',
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Email",
                                  style: AppTextStyle.default16w6,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _email,
                                decoration: AppFormStyle.textField(
                                  icon: Icons.email,
                                  hint: "Email",
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Password",
                                  style: AppTextStyle.default16w6,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _password,
                                obscureText: _obscure,
                                obscuringCharacter: '*',
                                decoration: AppFormStyle.passwordField(
                                  hint: "Password",
                                  obscureText: _obscure,
                                  onToggle: () {
                                    setState(() {
                                      _obscure = !_obscure;
                                    });
                                  },
                                ),
                              ),
                              if (!isLogin) ...[
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Konfirmasi Password",
                                    style: AppTextStyle.default16w6,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _confirmPassword,
                                  obscureText: _obscure,
                                  obscuringCharacter: '*',
                                  decoration: AppFormStyle.passwordField(
                                    hint: "Konfirmasi Password",
                                    obscureText: _obscure,
                                    onToggle: () {
                                      setState(() {
                                        _obscure = !_obscure;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20, // jarak dari bawah
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: AppButtonStyle.primaryButton,
                    onPressed: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: Text(
                      isLogin ? "Masuk" : "Daftar",
                      style: AppTextStyle.popins18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLogin ? "Belum punya akun ?" : "Sudah punya akun ?",
                        style: AppTextStyle.popins14,
                      ),
                      TextButton(
                        onPressed: toggleForm,
                        child: Text(
                          isLogin ? "Daftar" : "Masuk",
                          style: AppTextStyle.popins14.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColor.primaryBlue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
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
