import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/auth/presentasions/pages/login_register_page.dart';
import 'package:rumah_vokasi/features/mains/models/user_profile_model.dart';
import 'package:rumah_vokasi/features/mains/presentasions/pp_bookmark_page.dart';
import 'package:rumah_vokasi/features/mains/presentasions/pp_certificate.dart';
import 'package:rumah_vokasi/features/mains/presentasions/pp_changepw_page.dart';
import 'package:rumah_vokasi/features/mains/presentasions/pp_history_page.dart';
import 'package:rumah_vokasi/features/mains/presentasions/pp_profile_page.dart';
import 'package:rumah_vokasi/features/mains/services/user_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HpProfile extends StatefulWidget {
  const HpProfile({super.key});

  @override
  State<HpProfile> createState() => _HpProfileState();
}

class _HpProfileState extends State<HpProfile> {
  String? name;
  String? email;
  String? bio;
  String? phone;
  String? token;
  String? userID;
  String? profilePhoto;

  ProfileData? profile;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (image == null) return;

    final bytes = await File(image.path).readAsBytes();
    final base64Image = base64Encode(bytes);

    await UserProfileService().updateProfile(
      userID: userID!,
      name: name!,
      email: email!,
      profilePicture: base64Image,
      bio: bio!,
      phone: phone!,
      address: "",
      experience: "",
      specialist: "",
      document: "",
      token: token!,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profile_photo", base64Image);

    setState(() {
      profilePhoto = base64Image;
    });
  }

  void showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Ambil dari Kamera"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Pilih dari Galeri"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.close),
                title: Text("Batal"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> loadUserFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name");
      email = prefs.getString("email");
      token = prefs.getString("access_token");
      userID = prefs.getString("user_id");
      profilePhoto = prefs.getString("profile_photo");
    });

    if (token != null && userID != null) {
      loadData(token!, userID!);
    }
  }

  Future<void> loadData(String token, String userID) async {
    final response = await UserProfileService().getProfile(token, userID);
      profile = response;
      bio = profile?.bio;
      phone = profile?.phone;
  }

  void logoutUser() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: "Logout",
      text: "Apakah anda ingin logout ?",
      confirmBtnText: "OK",
      confirmBtnColor: Colors.green,
      showConfirmBtn: true,
      onConfirmBtnTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginRegisterPage(initialLogin: true),
          ),
        );
      },
      showCancelBtn: true,
      cancelBtnText: "Cancel",
      cancelBtnTextStyle: TextStyle(color: Colors.red),
      onCancelBtnTap: () {
        return;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadUserFromSP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 25),
          child: Image.asset('assets/images/Primary-Logo.png', height: 50),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          Align(
            alignment: AlignmentGeometry.topCenter,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: profilePhoto == null
                        ? Image.asset(
                            'assets/images/eula-slide-1.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Image.memory(
                            base64Decode(profilePhoto!),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    right: 3,
                    bottom: 3,
                    child: GestureDetector(
                      onTap: () {
                        if (userID == null || token == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Sedang memuat data...")),
                          );
                          return;
                        }
                        showPhotoOptions();
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColor.primaryDarkBlue4,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      name ?? "",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.popins18.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      email ?? "",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.popins16.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColor.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PpCertificate()),
                );
              },
              child: Container(
                height: 120,
                width: 350,
                margin: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 30,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColor.primaryLightBlue,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColor.primaryBlue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/sertif.svg',
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 2,
                          height: 50,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sertifikat Saya',
                              style: AppTextStyle.popins16.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: Text(
                                'Lihat sertifikat Anda sebagai bukti pencapaian dan keahlian!',
                                style: AppTextStyle.popins10w6.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            child: Column(
              children: [
                buildProfileMenu(
                  icon: Icons.person_outline,
                  title: "Profile Saya",
                  subtitle: "Lengkapi data diri Anda disini!",
                  iconColor: Colors.black,
                  titleColor: Colors.black87,
                  subColor: Colors.grey.shade500,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PpProfilePage()),
                    );
                  },
                ),
                buildProfileMenu(
                  icon: Icons.lock_outline,
                  title: "Ganti Password",
                  subtitle: "Perbaharui password Anda disini!",
                  iconColor: Colors.black,
                  titleColor: Colors.black87,
                  subColor: Colors.grey.shade500,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PpChangepwPage()),
                    );
                  },
                ),
                buildProfileMenu(
                  icon: Icons.access_time_sharp,
                  title: "Riwayat Pembelian",
                  subtitle: "lihat riwayat pembelian Anda!",
                  iconColor: Colors.black,
                  titleColor: Colors.black87,
                  subColor: Colors.grey.shade500,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PpHistoryPage()),
                    );
                  },
                ),
                buildProfileMenu(
                  icon: Icons.bookmark_border,
                  title: "Bookmark",
                  subtitle: "Lihat kursus yang anda disimpan!",
                  iconColor: Colors.black,
                  titleColor: Colors.black87,
                  subColor: Colors.grey.shade500,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PpBookmarkPage()),
                    );
                  },
                ),
                buildProfileMenu(
                  icon: Icons.exit_to_app_rounded,
                  title: "Keluar",
                  subtitle: "Keluar dari sesi ini!",
                  iconColor: Colors.red,
                  titleColor: Colors.red.shade300,
                  subColor: Colors.red.shade400,
                  onTap: () {
                    logoutUser();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileMenu({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color titleColor,
    required Color subColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 13, color: subColor),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
