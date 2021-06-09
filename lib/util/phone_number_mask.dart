class PhoneNumberMask {
  static Map<String, RegExp> _filter = {
    '#': RegExp('[0-9]'),
  };

  static String format({
    required String text,
    required String mask,
  }) {
    return _applyMask(text, mask);
  }

  static String _applyMask(String text, String mask) {
    final result = StringBuffer();

    int maskCharIndex = 0;
    int valueCharIndex = 0;

    while (true) {
      if (maskCharIndex == mask.length) {
        break;
      }

      if (valueCharIndex == text.length) {
        break;
      }

      var maskChar = mask[maskCharIndex];
      var valueChar = text[valueCharIndex];

      if (maskChar == valueChar) {
        result.write(maskChar);
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      if (_filter.containsKey(maskChar)) {
        if (_filter[maskChar]!.hasMatch(valueChar)) {
          result.write(valueChar);
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      result.write(maskChar);
      maskCharIndex += 1;
      continue;
    }

    return result.toString();
  }
}
