import 'package:flutter/material.dart';

class PinInputController extends TextEditingController {
  PinInputController({
    String? text,
  }) : super(text: text) {
    addListener(_moveCursorToEnd);
  }

  void _moveCursorToEnd() {
    selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
  }

  @override
  void dispose() {
    removeListener(_moveCursorToEnd);
    super.dispose();
  }
}
