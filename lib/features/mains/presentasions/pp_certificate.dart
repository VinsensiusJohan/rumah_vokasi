import 'package:flutter/material.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_form_style.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/features/mains/models/certificate_model.dart';
import 'package:rumah_vokasi/utils/dummy_data.dart';

class PpCertificate extends StatefulWidget {
  const PpCertificate({super.key});

  @override
  State<PpCertificate> createState() => _PpCertificateState();
}

class _PpCertificateState extends State<PpCertificate> {
  List<Certificate> certificates = [];

  @override
  void initState() {
    super.initState();
    certificates = sertifikat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Sertifikat",
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
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: AppFormStyle.searchField(
                  icon: Icons.search,
                  hint: 'Cari Sertifikat',
                ),
              ),
            ),
            if (certificates.isEmpty)
              Center(child: Text("Belum ada Sertifikat"))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: certificates.length,
                itemBuilder: (context, index) {
                  final certificate = certificates[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey.shade100),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        ClipRect(
                          child: Align(
                            alignment: Alignment.topCenter,
                            heightFactor: 0.5,
                            child: Image.asset(
                              certificate.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                certificate.title,
                                style: AppTextStyle.popins18.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                certificate.name,
                                style: AppTextStyle.inter12.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.textGrey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: certificate.bab.asMap().entries.map(
                                    (entry) {
                                      final index = entry.key;
                                      final babName = entry.value;

                                      final colors = [
                                        AppColor.primaryBlue,
                                        AppColor.yellow,
                                        AppColor.green,
                                      ];

                                      final color =
                                          colors[index % colors.length];

                                      return Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          babName,
                                          style: AppTextStyle.popins12wBold
                                              .copyWith(
                                                color: color,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      );
                                    },
                                  ).toList(),
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
          ],
        ),
      ),
    );
  }
}
