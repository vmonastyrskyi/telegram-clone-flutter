import 'package:flutter/material.dart';

class MaskedTextController extends TextEditingController {
  static Map<String, RegExp> defaultFilter = {
    'A': RegExp(r'[A-Za-z]'),
    '0': RegExp(r'[0-9]'),
    '@': RegExp(r'[A-Za-z0-9]'),
    '*': RegExp(r'.*')
  };

  MaskedTextController({
    String? text,
    required this.mask,
    Map<String, RegExp>? filter,
  }) : super(text: text) {
    this.filter = filter ?? defaultFilter;

    addListener(() {
      formatText(this.text);
    });

    formatText(this.text);
  }

  String mask;
  Map<String, RegExp>? filter;

  void formatText(String text) {
    this.text = _applyMask(this.mask, text);
  }

  void changeMask(String mask) {
    this.mask = mask;
    formatText(text);
    moveCursorToEnd();
  }

  void moveCursorToEnd() {
    selection = TextSelection.fromPosition(TextPosition(offset: (text).length));
  }

  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.trim().length),
      composing: TextRange.empty,
    );
  }

  bool isValid() {
    return text.length == mask.length;
  }

  String _applyMask(String mask, String value) {
    String result = '';

    var maskCharIndex = 0;
    var valueCharIndex = 0;
    var filter = this.filter!;

    while (true) {
      if (maskCharIndex == mask.length) break;

      if (valueCharIndex == value.length) break;

      var maskChar = mask[maskCharIndex];
      var valueChar = value[valueCharIndex];

      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      if (filter.containsKey(maskChar)) {
        if (filter[maskChar]!.hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }
}
