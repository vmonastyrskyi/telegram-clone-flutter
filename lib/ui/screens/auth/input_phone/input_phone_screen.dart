import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/business_logic/models/country.dart';
import 'package:telegram_clone_mobile/business_logic/view_models/choose_country.dart';
import 'package:telegram_clone_mobile/services/firebase/firebase_auth_service.dart';
import 'package:telegram_clone_mobile/ui/screens/auth/router.dart';
import 'package:telegram_clone_mobile/ui/widgets/modal.dart';
import 'package:telegram_clone_mobile/util/masked_text_controller.dart';
import 'package:vibration/vibration.dart';

class InputPhoneScreen extends StatefulWidget {
  @override
  _InputPhoneScreenState createState() => _InputPhoneScreenState();
}

class _InputPhoneScreenState extends State<InputPhoneScreen>
    with SingleTickerProviderStateMixin {
  static final String _kDefaultPhoneMask = '###############';
  static final int _kVibrationDuration = 175;
  static final int _kShakeDuration = 350;

  late final AnimationController _phoneAnimationController;
  late final Animation<Offset> _phoneInputOffset;

  final TextEditingController _countryCodeInputController =
      TextEditingController();
  final MaskedTextController _phoneInputController =
      MaskedTextController(mask: _kDefaultPhoneMask, filter: {
    '#': RegExp(r'[0-9]'),
  });
  final PhoneMaskPainter _maskPainter = PhoneMaskPainter();

  late String _selectedCountryName = 'Choose a country';
  bool _isValidCountryCode = false;

  @override
  void initState() {
    super.initState();

    _phoneAnimationController = AnimationController(
      duration: Duration(milliseconds: _kShakeDuration),
      vsync: this,
    )..value = 1.0;

    _phoneInputOffset =
        Tween<Offset>(begin: Offset(0.0125, 0), end: Offset.zero)
            .chain(CurveTween(curve: SineCurve(waves: 3)))
            .animate(_phoneAnimationController);
  }

  @override
  void dispose() {
    _phoneAnimationController.dispose();
    _countryCodeInputController.dispose();
    _phoneInputController.dispose();
    super.dispose();
  }

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
              _selectedCountryName = selectedCountry.name;
              _countryCodeInputController.text =
                  selectedCountry.code.toString();
              _countryCodeInputController.selection =
                  TextSelection.fromPosition(TextPosition(
                      offset: _countryCodeInputController.text.length));
              _phoneInputController.changeMask(selectedCountry.mask);
              _maskPainter.fill(_phoneInputController.text);
              _maskPainter.changeMask(selectedCountry.mask);
              _isValidCountryCode = true;
            } else {
              _phoneInputController.changeMask(_kDefaultPhoneMask);
              _maskPainter.fill('');
              _maskPainter.changeMask('');
              _isValidCountryCode = false;
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
        onPressed: () async {
          if (_countryCodeInputController.text.isEmpty) {
            _showAlert(title: 'Telegram', message: 'Choose a country');
          } else if (!_isValidCountryCode) {
            _showAlert(title: 'Telegram', message: 'Invalid country code');
          } else if (_phoneInputController.text.isEmpty) {
            Vibration.vibrate(duration: _kVibrationDuration);
            _phoneAnimationController.forward(from: 0.0);
          } else if (!_phoneInputController.isValid()) {
            _showAlert(
                title: 'Telegram',
                message:
                    'Invalid phone number. Please check the number and try again.');
          }
          // else {
          //   context.read<FirebaseAuthService>().signInWithPhoneNumber(
          //     '+380955584480',
          //     (credential) {
          //       print(credential);
          //       print(credential.smsCode);
          //     },
          //     (error) {
          //       if (error.code == 'invalid-phone-number') {
          //         print('The provided phone number is not valid.');
          //       }
          //     },
          //     (verificationId, resendToken) {
          //       print(verificationId);
          //     },
          //     (verificationId) {},
          //   );
          // }
        },
        splashColor: Colors.white.withOpacity(0.25),
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Future<void> _showAlert(
      {required String title, required String message}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Modal(
          title: title,
          content: Text(
            message,
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).textTheme.headline1!.color,
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              minWidth: 64,
              height: 36,
              padding: EdgeInsets.zero,
              child: Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
            hintText: _selectedCountryName,
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

  void _handleCodeInput(String text) {
    if (text.isNotEmpty) {
      Country? country = context
          .read<ChooseCountryProvider>()
          .findCountryByCode(int.parse(text));

      if (country != null)
        setState(() => _selectedCountryName = country.name);
      else
        setState(() => _selectedCountryName = 'Invalid country code');
      context.read<ChooseCountryProvider>().selectedCountry = country;
    } else {
      setState(() => _selectedCountryName = 'Choose a country');
      context.read<ChooseCountryProvider>().selectedCountry = null;
    }
  }

  Widget _buildPhoneInput() {
    final theme = Theme.of(context);

    return Expanded(
      flex: 4,
      child: Container(
        margin: const EdgeInsets.only(left: 9),
        child: SlideTransition(
          position: _phoneInputOffset,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              CustomPaint(painter: _maskPainter),
              TextField(
                controller: _phoneInputController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                ],
                onChanged: (_) {
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
      ),
    );
  }

  Widget _buildHint() {
    return const Text(
      'Please confirm your country code and enter your phone number.',
      style: const TextStyle(
          color: const Color.fromARGB(255, 125, 138, 147), height: 1.25),
    );
  }
}

class SineCurve extends Curve {
  SineCurve({this.waves = 3});

  final double waves;

  @override
  double transformInternal(double t) {
    return -sin(waves * 2 * pi * t);
  }
}

class PhoneMaskPainter extends CustomPainter {
  static const double _kCharGap = 2.0;
  static const double _kCharWidth = 8.0;
  static const double _kCharHeight = 2.0;
  static const double _kSpaceWidth = 3.0;

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
        (_kSpaceWidth * ' '.allMatches(text).length);

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
        charPositionX -= _kSpaceWidth;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
