import 'package:flutter/material.dart';
import 'package:rumah_vokasi/core/app_color.dart';
import 'package:rumah_vokasi/core/app_form_style.dart';
import 'package:rumah_vokasi/core/app_text_style.dart';
import 'package:rumah_vokasi/utils/dummy_data.dart';
import 'package:rumah_vokasi/utils/app_formater.dart';

class PpHistoryPage extends StatefulWidget {
  const PpHistoryPage({super.key});

  @override
  State<PpHistoryPage> createState() => _PpHistoryPageState();
}

class _PpHistoryPageState extends State<PpHistoryPage> {
  final TextEditingController _search = TextEditingController();

  late List<bool> _isExpandedList;

  @override
  void initState() {
    super.initState();
    _isExpandedList = List.generate(histories.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Riwayat Pembelian",
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
                controller: _search,
                decoration: AppFormStyle.searchField(
                  icon: Icons.search,
                  hint: 'Cari Riwayat Pembelian',
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: histories.length,
              itemBuilder: (context, index) {
                final paymentHistory = histories[index];
                final isExpanded = _isExpandedList[index];
                return SizedBox(
                  child: ExpansionTile(
                    title: Text(
                      '${paymentHistory.tanggal} at ${paymentHistory.jam}',
                      style: AppTextStyle.popins16.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.primaryDarkBlue3,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          color: AppColor.purpleBlue,
                          size: 25,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${paymentHistory.totalCourse} Kursus",
                          style: AppTextStyle.popins16.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColor.textGrey,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Icon(
                          Icons.attach_money_outlined,
                          color: AppColor.primaryBlue,
                          size: 25,
                        ),
                        Text(
                          AppFormater.formatPriceID(
                            paymentHistory.totalPrice,
                            withSymbol: true,
                          ),
                          style: AppTextStyle.inter16.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down_outlined
                          : Icons.keyboard_arrow_right_outlined,
                      color: isExpanded ? Colors.black : AppColor.primaryBlue,
                    ),
                    onExpansionChanged: (bool expanded) {
                      setState(() {
                        _isExpandedList[index] = expanded;
                      });
                    },
                    children: paymentHistory.listKursus.map((kursus) {
                      return Card(
                        margin: EdgeInsets.fromLTRB(20, 5, 20, 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(20),
                          side: BorderSide(color: Colors.grey.shade100),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    kursus.image,
                                    width: 80,
                                    height: 100,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          kursus.title,
                                          style: AppTextStyle.popins16.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          kursus.name,
                                          style: AppTextStyle.regular12
                                              .copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.textGrey,
                                              ),
                                          textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(height: 4),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: kursus.bab
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                                  final index = entry.key;
                                                  final babName = entry.value;

                                                  final colors = [
                                                    AppColor.primaryBlue,
                                                    AppColor.yellow,
                                                    AppColor.green,
                                                  ];

                                                  final color =
                                                      colors[index %
                                                          colors.length];

                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                          right: 8,
                                                        ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: color.withValues(
                                                        alpha: 0.15,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      babName,
                                                      style: AppTextStyle
                                                          .popins12wBold
                                                          .copyWith(
                                                            color: color,
                                                          ),
                                                    ),
                                                  );
                                                })
                                                .toList(),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          AppFormater.formatPriceID(
                                            kursus.harga,
                                          ),
                                          style: AppTextStyle.popins18.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.primaryBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 50,
                              margin: EdgeInsets.only(
                                left: 15,
                                right: 15,
                                bottom: 15,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppColor.green3.withValues(alpha: 0.2),
                              ),
                              child: Text(
                                kursus.statusPembayaran,
                                style: AppTextStyle.inter18.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.green3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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
