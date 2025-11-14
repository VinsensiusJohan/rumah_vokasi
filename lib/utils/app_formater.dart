import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppFormater {
  static String formatPriceID(num number, {bool withSymbol = true}){
    final formatCurrency = NumberFormat.currency(
      locale: 'id',
      symbol: withSymbol ? 'Rp ' : '',
      decimalDigits: 0
    );
    return formatCurrency.format(number);
  }
  static String formatNumber(num value, {int decimalDigits = 0}) {
    final format = NumberFormat.currency(
      locale: 'id',            
      symbol: '',             
      decimalDigits: decimalDigits,
    );
    return format.format(value).trim();
  }
  
  static TextInputFormatter dateTextFormatter = _DateTextFormatter();

}

class _DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length >= 3 && text.length <= 4) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    } else if (text.length > 4) {
      text =
          '${text.substring(0, 2)}/${text.substring(2, 4)}/${text.substring(4)}';
    } else if (text.length > 2) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}