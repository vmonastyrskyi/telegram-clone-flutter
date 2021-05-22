import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:telegram_clone_mobile/util/pin_input_controller.dart';

class PinInput {
  PinInput(this.name) {
    this._controller = PinInputController();
    this._rkFocusNode = FocusNode();
    this._tfFocusNode = FocusNode();
  }

  final String name;
  late final PinInputController _controller;
  late final FocusNode _rkFocusNode;
  late final FocusNode _tfFocusNode;

  PinInputController get controller => _controller;

  FocusNode get rkFocusNode => _rkFocusNode;

  FocusNode get tfFocusNode => _tfFocusNode;
}

class PinInputEntry extends LinkedListEntry<PinInputEntry> {
  PinInputEntry(this.input);

  final PinInput input;

  void dispose() {
    input.controller.dispose();
    input.rkFocusNode.dispose();
    input.tfFocusNode.dispose();
  }
}

class PinInputFormatter with TextInputFormatter {
  const PinInputFormatter.create(this.entry);

  final PinInputEntry entry;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final StringBuffer result = StringBuffer();

    final String text = newValue.text;
    final int length = newValue.text.length;
    final int offset = newValue.selection.baseOffset;

    if (length == 1 && offset == 1) {
      result.write(text);
      if (entry.next != null) {
        entry.next!.input.tfFocusNode.requestFocus();
      }
    } else if (length > 1 && offset > 1) {
      if (entry.next != null) {
        result.write(text[0]);
        entry.next!.input.controller.text = text[1];
        entry.next!.input.tfFocusNode.requestFocus();
      } else {
        result.write(oldValue.text);
      }
    }

    return newValue.copyWith(
      text: result.toString(),
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
