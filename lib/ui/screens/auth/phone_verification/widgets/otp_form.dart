import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:telegram_clone_mobile/util/pin_input_formatter.dart';

class OtpForm extends StatefulWidget {
  final String inputPrefix;
  final int length;
  final bool autoSubmit;
  final void Function(String)? onSubmit;
  final void Function(String)? onEditingComplete;

  const OtpForm({
    Key? key,
    required this.inputPrefix,
    required this.length,
    this.autoSubmit = true,
    this.onSubmit,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  OtpFormState createState() => OtpFormState();
}

class OtpFormState extends State<OtpForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();
  final LinkedList<PinInputEntry> _inputs = LinkedList();

  bool _enabled = true;

  set enabled(bool value) {
    setState(() {
      _enabled = value;
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.length; i++) {
      _inputs.add(PinInputEntry(PinInput('${widget.inputPrefix}${i + 1}')));
    }
    _inputs.first.input.tfFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _inputs.forEach((entry) => entry.dispose());
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      enabled: _enabled,
      onChanged: () {
        if (_enabled && widget.autoSubmit && widget.onSubmit != null) {
          final code = _getCode();
          if (code.length == widget.length) {
            widget.onSubmit!(code);
          }
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (PinInputEntry entry in _inputs) _buildOtpCodeInput(entry: entry)
        ],
      ),
    );
  }

  void fillAndDisable(String code) {
    enabled = false;
    _inputs.toList().asMap().forEach((index, entry) {
      entry.input.controller.text = code[index];
    });
    _inputs.last.input.tfFocusNode.requestFocus();
  }

  void reset() {
    _inputs.toList().asMap().forEach((index, entry) {
      entry.input.controller.clear();
    });
    _inputs.first.input.tfFocusNode.requestFocus();
  }

  Widget _buildOtpCodeInput({required PinInputEntry entry}) {
    final inputBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).accentColor,
        width: 2.0,
      ),
    );

    return Container(
      width: 36.0,
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      child: RawKeyboardListener(
        focusNode: entry.input.rkFocusNode,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
            _requestPreviousFocus(entry);
          }
        },
        child: FormBuilderTextField(
          name: entry.input.name,
          focusNode: entry.input.tfFocusNode,
          controller: entry.input.controller,
          onEditingComplete: () {
            if (widget.onEditingComplete != null) {
              widget.onEditingComplete!(_getCode());
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            PinInputFormatter.create(entry),
          ],
          textAlign: TextAlign.center,
          cursorColor: Theme.of(context).textTheme.headline1!.color,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          cursorWidth: 2.0,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.headline1!.color,
          ),
          decoration: InputDecoration(
            enabledBorder: inputBorder,
            disabledBorder: inputBorder,
            focusedBorder: inputBorder,
            errorBorder: inputBorder,
            focusedErrorBorder: inputBorder,
            errorStyle: const TextStyle(fontSize: 0, height: 0),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
          ),
        ),
      ),
    );
  }

  String _getCode() {
    final StringBuffer code = StringBuffer();
    _inputs.forEach((entry) => code.write(entry.input.controller.text));
    return code.toString();
  }

  void _requestPreviousFocus(PinInputEntry entry, {bool clearPrevious = true}) {
    if (entry.previous != null &&
        entry.previous!.input.controller.text.isEmpty) {
      if (entry.input.controller.text.isEmpty && clearPrevious) {
        entry.previous!.input.controller.text = '';
        _requestPreviousFocus(entry.previous!);
      } else {
        _requestPreviousFocus(entry.previous!, clearPrevious: false);
      }
    } else if (entry.previous != null &&
        entry.previous!.input.controller.text.isNotEmpty) {
      if (entry.input.controller.text.isEmpty && clearPrevious) {
        entry.previous!.input.controller.text = '';
        _requestPreviousFocus(entry.previous!, clearPrevious: false);
      } else {
        entry.previous!.input.tfFocusNode.requestFocus();
      }
    } else {
      entry.input.tfFocusNode.requestFocus();
    }
  }
}
