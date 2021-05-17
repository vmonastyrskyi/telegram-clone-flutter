import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/business_logic/models/country.dart';
import 'package:telegram_clone_mobile/business_logic/view_models/choose_country.dart';
import 'package:telegram_clone_mobile/ui/screens/auth/router.dart';
import 'package:telegram_clone_mobile/util/masked_text_controller.dart';

class InputPhoneScreen extends StatefulWidget {
  @override
  _InputPhoneScreenState createState() => _InputPhoneScreenState();
}

class _InputPhoneScreenState extends State<InputPhoneScreen> {
  static final String _kDefaultPhoneMask = '###############';

  final TextEditingController _countryCodeInputController =
      TextEditingController();
  final MaskedTextController _phoneInputController =
      MaskedTextController(mask: _kDefaultPhoneMask, filter: {
    '#': RegExp(r'[0-9]'),
  });
  final MaskPainter _maskPainter = MaskPainter();

  late String hintText = 'Choose a country';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Your Phone'),
        elevation: 1.5,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 32,
        ),
        child: Consumer<ChooseCountryProvider>(
          builder: (_, provider, __) {
            Country? selectedCountry = provider.selectedCountry;
            if (selectedCountry != null) {
              hintText = selectedCountry.name;
              _countryCodeInputController.text =
                  selectedCountry.code.toString();
              _countryCodeInputController.selection =
                  TextSelection.fromPosition(TextPosition(
                      offset: _countryCodeInputController.text.length));
              _phoneInputController
                  .changeMask(selectedCountry.mask);
              _maskPainter.changeMask(selectedCountry.mask);
            } else {
              _phoneInputController.changeMask(_kDefaultPhoneMask);
              _maskPainter.changeMask('');
            }

            return Column(
              children: <Widget>[
                _buildChooseCountryButton(),
                SizedBox(height: 18),
                Row(
                  children: <Widget>[
                    _buildCodeInput(),
                    _buildPhoneInput(),
                  ],
                ),
                SizedBox(height: 32),
                _buildHint(),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildChooseCountryButton() {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => Navigator.pushNamed(context, AuthRoutes.ChooseCountry),
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 1, 4, 3),
        child: TextField(
          enabled: false,
          enableInteractiveSelection: false,
          style: TextStyle(
            color: theme.textTheme.headline1!.color,
          ),
          decoration: InputDecoration(
            disabledBorder: const UnderlineInputBorder(
              borderSide: const BorderSide(
                color: const Color.fromARGB(255, 201, 212, 216),
              ),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: theme.textTheme.headline1!.color,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInput() {
    final theme = Theme.of(context);

    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.only(right: 9),
        child: TextField(
          onChanged: _handleCodeInput,
          inputFormatters: [
            LengthLimitingTextInputFormatter(4),
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          controller: _countryCodeInputController,
          cursorColor: theme.textTheme.headline1!.color,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          style: TextStyle(
            color: theme.textTheme.headline1!.color,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            prefixIcon: Text(
              '\+',
              style: TextStyle(
                color: theme.textTheme.headline1!.color,
                fontSize: 18,
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            enabledBorder: const UnderlineInputBorder(
              borderSide: const BorderSide(
                color: const Color.fromARGB(255, 78, 85, 98),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.accentColor,
                width: 2,
              ),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 6,
            ),
          ),
        ),
      ),
    );
  }

  void _handleCodeInput(String value) {
    if (value.isNotEmpty) {
      Country? country = context
          .read<ChooseCountryProvider>()
          .findCountryByCode(int.parse(value));

      if (country != null)
        setState(() => hintText = country.name);
      else
        setState(() => hintText = 'Invalid country code');
      context.read<ChooseCountryProvider>().selectedCountry = country;
    } else {
      setState(() => hintText = 'Choose a country');
      context.read<ChooseCountryProvider>().selectedCountry = null;
    }
  }

  Widget _buildPhoneInput() {
    final theme = Theme.of(context);

    return Expanded(
      flex: 4,
      child: Container(
        margin: const EdgeInsets.only(left: 9),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            CustomPaint(painter: _maskPainter),
            TextField(
              controller: _phoneInputController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
              ],
              onChanged: (value) {
                _maskPainter.fill(_phoneInputController.text);
              },
              autofocus: true,
              cursorColor: theme.textTheme.headline1!.color,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                color: theme.textTheme.headline1!.color,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: const BorderSide(
                    color: const Color.fromARGB(255, 78, 85, 98),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: theme.accentColor,
                    width: 2,
                  ),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHint() {
    return const Text(
      'Please confirm your country code and enter your phone number.',
      style: const TextStyle(
        color: const Color.fromARGB(255, 125, 138, 147),
        height: 1.25
      ),
    );
  }
}

class MaskPainter extends CustomPainter {
  static const double _kCharGap = 2.0;
  static const double _kSpaceGap = 3.0;
  static const double _kCharWidth = 8.0;
  static const double _kCharHeight = 2.0;

  String mask = '';
  String text = '';

  void changeMask(String mask) {
    this.mask = mask;
  }

  void fill(String text) {
    this.text = text;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color.fromARGB(255, 125, 138, 147)
      ..style = PaintingStyle.fill;

    double charPositionX = 1;

    charPositionX += _kCharGap * text.replaceAll(' ', '').length -
        (_kSpaceGap * ' '.allMatches(text).length);

    for (int i = text.length; i < mask.length; i++) {
      if (mask[i] != ' ') {
        Path path = Path();
        path.moveTo(charPositionX + (i * _kCharWidth), 0);
        path.lineTo(charPositionX + (i * _kCharWidth) + _kCharWidth, 0);
        path.lineTo(
            charPositionX + (i * _kCharWidth) + _kCharWidth, _kCharHeight);
        path.lineTo(charPositionX + (i * _kCharWidth), _kCharHeight);
        path.close();

        canvas.drawPath(path, paint);

        charPositionX += _kCharGap;
      } else {
        charPositionX -= _kSpaceGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
