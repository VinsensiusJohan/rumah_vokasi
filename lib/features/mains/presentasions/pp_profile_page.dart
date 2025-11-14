import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rumah_vokasi/core/app_button_style.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_form_style.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/utils/app_formater.dart';

class PpProfilePage extends StatefulWidget {
  const PpProfilePage({super.key});

  @override
  State<PpProfilePage> createState() => _PpProfilePageState();
}

class _PpProfilePageState extends State<PpProfilePage> {
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _telepon = TextEditingController();
  final TextEditingController _tanggalLahir = TextEditingController();
  String? _jenisKelamin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bookmark",
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
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 10),
            Align(
              alignment: AlignmentGeometry.topCenter,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(80),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/eula-slide-1.png',
                                height: 90,
                              ),
                            ),
                            Positioned(
                              right: 4,
                              bottom: 4,
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
                          ],
                        ),
                      ),
                      Text(
                        "Manusia Bumi Setengah Alien",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.popins18.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "setAliensetManusia@gmail.com",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.popins16.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColor.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bio",
                    style: AppTextStyle.popins16.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: TextFormField(
                      expands: true, 
                      maxLines: null, 
                      minLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      controller: _bio,
                      decoration: AppFormStyle.updateField(hint: '').copyWith(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Nama",
                    style: AppTextStyle.popins16.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    decoration: AppFormStyle.updateField(hint: ''),
                    controller: _nama,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Email",
                    style: AppTextStyle.popins16.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    decoration: AppFormStyle.updateField(hint: ''),
                    controller: _email,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Telepon",
                    style: AppTextStyle.popins16.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    decoration: AppFormStyle.updateField(hint: ''),
                    controller: _telepon,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tanggal Lahir",
                    style: AppTextStyle.popins16.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    decoration: AppFormStyle.updateField(hint: 'dd/mm/yyyy'),
                    controller: _tanggalLahir,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                      AppFormater.dateTextFormatter,
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tanggal Lahir",
                    style: AppTextStyle.popins16.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: _jenisKelamin,
                    decoration: AppFormStyle.dropdownField(
                      hint: "Jenis Kelamin",
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Laki-laki",
                        child: Text("Laki-laki"),
                      ),
                      DropdownMenuItem(
                        value: "Perempuan",
                        child: Text("Perempuan"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _jenisKelamin = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jenis Kelamin wajib diisi!';
                      } else {
                        return null;
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 50),
        child: ElevatedButton(
          style: AppButtonStyle.primaryButton,
          onPressed: () {},
          child: Text(
            "Simpan & Ubah",
            style: AppTextStyle.popins18.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
