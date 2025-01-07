import 'package:flutter/services.dart';

TextInputFormatter customPhoneFormatter(String phoneFormat) {
  List<String> formatParts = phoneFormat.split(" ");

  return TextInputFormatter.withFunction((oldValue, newValue) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String result = '';
    int textIndex = 0;

    for (int i = 0; i < formatParts.length; i++) {
      String part = formatParts[i];

      for (int j = 0; j < part.length; j++) {
        if (textIndex < text.length) {
          result += text[textIndex];
          textIndex++;
        }
      }

      if (i < formatParts.length - 1 && textIndex < text.length) {
        result += ' ';
      }
    }

    if (textIndex < text.length) {
      result += text.substring(textIndex);
    }

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  });
}
