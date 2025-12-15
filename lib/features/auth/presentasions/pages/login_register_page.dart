import 'package:flutter/material.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_form_style.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/auth/services/login_register_services.dart';
import 'package:rumah_vokasi/features/mains/presentasions/home_page.dart';
import 'package:quickalert/quickalert.dart';

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

  final LoginRegisterServices serviceLoginRegister = LoginRegisterServices();

  bool isLogin = true;
  bool _obscure = true;

  bool nameError = false;
  bool emailError = false;
  bool passwordError = false;
  bool confirmPasswordError = false;

  String? apiError;

  Future<void> userRegister() async {
    setState(() {
      nameError = false;
      emailError = false;
      passwordError = false;
      confirmPasswordError = false;
    });

    String name = _nama.text.trim();
    String email = _email.text.trim();
    String password = _password.text.trim();
    String confirmPassword = _confirmPassword.text.trim();

    bool isValid = true;

    if (name.isEmpty) {
      setState(() => nameError = true);
      isValid = false;
    }

    if (email.isEmpty || !email.contains("@") && !email.contains(".")) {
      setState(() => emailError = true);
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() => passwordError = true);
      isValid = false;
    }

    if (confirmPassword.isEmpty || confirmPassword != password) {
      setState(() => confirmPasswordError = true);
      isValid = false;
    }

    if (!isValid) {
      return;
    } else {
      submitRegister(name, email, password);
    }
  }

  Future<void> userLogin() async {
    setState(() {
      emailError = false;
      passwordError = false;
    });

    bool isValid = true;

    String email = _email.text.trim();
    String password = _password.text.trim();

    if (email.isEmpty || !email.contains("@") && !email.contains(".")) {
      setState(() => emailError = true);
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() => passwordError = true);
      isValid = false;
    }

    if (!isValid) {
      return;
    } else {
      submitLogin(email, password);
    }
  }

  Future<void> submitLogin(String email, String password) async {
    try {
      final response = await serviceLoginRegister.loginUser(
        email: email,
        password: password,
      );

      final role = response['role'];

      if (!mounted) {
        return;
      }

      if (role != "STUDENT") {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          animType: QuickAlertAnimType.scale,
          title: 'Gagal',
          text: 'Kesalahan Masuk',
          confirmBtnText: 'OK',
          barrierDismissible: true,
        );

        return;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(index: 0)),
        );
      }
    } catch (e) {
      setState(() {
        apiError = "Email atau Password salah!";
      });
    }
  }

  Future<void> submitRegister(
    String name,
    String email,
    String password,
  ) async {
    try {
      final result = await serviceLoginRegister.registerUser(
        name: name,
        email: email,
        password: password,
      );

      setState(() {
        isLogin = true;
      });

      debugPrint("Sukses: $result");
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    isLogin = widget.initialLogin;
  }

  void toggleForm() {
    setState(() {
      isLogin = !isLogin;
      nameError = false;
      emailError = false;
      passwordError = false;
      confirmPasswordError = false;
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

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset:
          true, // penting agar form naik saat keyboard muncul
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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

      // ===============================
      //   BOTTOM NAVIGATION BAR
      // ===============================
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: AppButtonStyle.primaryButton,
                onPressed: () {
                  if (!isLogin) {
                    userRegister();
                  } else {
                    userLogin();
                  }
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
      ),

      // =====================================================
      //                       BODY
      // =====================================================
      body: Container(
        color: Colors.white,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              /// --- BACKGROUND CIRCLE ---
              Positioned(
                top: isLogin ? 200 : 100,
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
        
              /// --- TOP IMAGE ---
              Positioned(
                left: isLogin ? (screenwidth / 2 - 100) : (screenwidth / 2 - 75),
                top: isLogin ? 80 : 10,
                child: Image.asset(
                  'assets/images/login-register.png',
                  width: isLogin ? 200 : 150,
                  height: isLogin ? 200 : 150,
                ),
              ),
        
              /// --- SCROLLING CONTENT ---
              Column(
                children: [
                  SizedBox(height: isLogin ? 250 : 150),
        
                  /// --- HEADER ---
                  Column(
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
                      const SizedBox(height: 10),
                    ],
                  ),
        
                  /// --- FORM AREA (scrollable) ---
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                  decoration:
                                      AppFormStyle.textField(
                                        icon: Icons.person,
                                        hint: 'Nama',
                                      ).copyWith(
                                        errorText: nameError
                                            ? "Nama tidak boleh kosong"
                                            : null,
                                      ),
                                ),
                                const SizedBox(height: 8),
                              ],
        
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
                                decoration:
                                    AppFormStyle.textField(
                                      icon: Icons.email,
                                      hint: "Email",
                                    ).copyWith(
                                      errorText: emailError
                                          ? "Email tidak valid"
                                          : apiError,
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
                                decoration:
                                    AppFormStyle.passwordField(
                                      hint: "Password",
                                      obscureText: _obscure,
                                      onToggle: () {
                                        setState(() {
                                          _obscure = !_obscure;
                                        });
                                      },
                                    ).copyWith(
                                      errorText: passwordError
                                          ? "Password tidak boleh kosong"
                                          : apiError,
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
                                  decoration:
                                      AppFormStyle.passwordField(
                                        hint: "Konfirmasi Password",
                                        obscureText: _obscure,
                                        onToggle: () {
                                          setState(() {
                                            _obscure = !_obscure;
                                          });
                                        },
                                      ).copyWith(
                                        errorText: confirmPasswordError
                                            ? "Password tidak sama"
                                            : null,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
