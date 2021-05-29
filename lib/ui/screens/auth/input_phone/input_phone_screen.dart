import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_clone_mobile/constants/shared_preferences.dart';
import 'package:telegram_clone_mobile/models/country.dart';
import 'package:telegram_clone_mobile/provider/select_country_provider.dart';
import 'package:telegram_clone_mobile/ui/screens/auth/phone_verification/phone_verification_screen.dart';
import 'package:telegram_clone_mobile/ui/screens/auth/router.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/modal.dart';
import 'package:telegram_clone_mobile/util/curves/sine_curve.dart';
import 'package:telegram_clone_mobile/util/masked_input_controller.dart';
import 'package:vibration/vibration.dart';

class InputPhoneScreen extends StatefulWidget {
  const InputPhoneScreen({Key? key}) : super(key: key);

  @override
  _InputPhoneScreenState createState() => _InputPhoneScreenState();
}

class _InputPhoneScreenState extends State<InputPhoneScreen>
    with SingleTickerProviderStateMixin {
  static final String _kDefaultPhoneMask = '###############';
  static final int _kVibrationDuration = 175;
  static final int _kShakeDuration = 350;

  late final AnimationController _phoneAnimationController;
  late final Animation<Offset> _phoneInputPosition;

  final TextEditingController _countryCodeInputController =
      TextEditingController();
  final MaskedInputController _phoneInputController =
      MaskedInputController(mask: _kDefaultPhoneMask, filter: {
    '#': RegExp('[0-9]'),
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
    _phoneInputPosition =
        Tween<Offset>(begin: Offset(0.0125, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: SineCurve(waves: 3)))
            .animate(_phoneAnimationController);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _autofillInputs();
    });
  }

  void _autofillInputs() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedCountryJson =
        prefs.getString(SharedPrefsConstants.kSelectedCountry);
    if (selectedCountryJson != null) {
      final selectedCountry = Country.fromJson(jsonDecode(selectedCountryJson));
      context.read<SelectCountryProvider>().selectedCountry = selectedCountry;

      final phoneNumber = prefs.getString(SharedPrefsConstants.kPhoneNumber);
      if (phoneNumber != null) {
        _phoneInputController.text = phoneNumber;
      }
    }
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
          horizontal: 18.0,
          vertical: 32.0,
        ),
        child: Consumer<SelectCountryProvider>(
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
                SizedBox(height: 18.0),
                Row(
                  children: <Widget>[
                    _buildCodeInput(),
                    _buildPhoneInput(),
                  ],
                ),
                SizedBox(height: 32.0),
                _buildHint(),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_countryCodeInputController.text.isEmpty) {
            _showAlert(
              title: 'Telegram',
              message: 'Choose a country.',
            );
          } else if (!_isValidCountryCode) {
            _showAlert(
              title: 'Telegram',
              message: 'Invalid country code.',
            );
          } else if (_phoneInputController.text.isEmpty) {
            Vibration.vibrate(duration: _kVibrationDuration);
            _phoneAnimationController.forward(from: 0.0);
          } else if (!_phoneInputController.isValid()) {
            _showAlert(
              title: 'Telegram',
              message:
                  'Invalid phone number. Please check the number and try again.',
            );
          } else {
            final localPhoneNumber =
                _phoneInputController.text.replaceAll(RegExp('[^0-9]'), '');
            final formattedPhoneNumber =
                '+${_countryCodeInputController.text} ${_phoneInputController.text}';
            final args = PhoneVerificationArgs(
              localPhoneNumber: localPhoneNumber,
              formattedPhoneNumber: formattedPhoneNumber,
            );
            Navigator.of(context)
                .pushNamed(AuthRoutes.PhoneVerification, arguments: args);
          }
        },
        splashColor: Colors.white.withOpacity(0.25),
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Future<void> _showAlert({
    required String title,
    required String message,
  }) async {
    return showGeneralDialog<void>(
      context: context,
      barrierLabel: '',
      barrierColor: Colors.black54,
      barrierDismissible: true,
      transitionBuilder: (_, animation, __, child) {
        final scale = animation.drive(Tween<double>(begin: 0.85, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)));
        final opacity = animation.drive(Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)));

        return ScaleTransition(
          scale: scale,
          child: FadeTransition(
            opacity: opacity,
            child: child,
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 250),
      pageBuilder: (context, _, __) {
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
              minWidth: 64.0,
              height: 36.0,
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
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AuthRoutes.SelectCountry),
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 3.0),
        child: TextField(
          enabled: false,
          enableInteractiveSelection: false,
          style: TextStyle(
            color: Theme.of(context).textTheme.headline1!.color,
          ),
          decoration: InputDecoration(
            disabledBorder: const UnderlineInputBorder(
              borderSide: const BorderSide(
                color: const Color.fromARGB(255, 201, 212, 216),
              ),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            hintText: _selectedCountryName,
            hintStyle: TextStyle(
              color: Theme.of(context).textTheme.headline1!.color,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInput() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.only(right: 9.0),
        child: TextField(
          onChanged: _handleCodeInput,
          inputFormatters: [
            LengthLimitingTextInputFormatter(4),
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
          ],
          controller: _countryCodeInputController,
          cursorColor: Theme.of(context).textTheme.headline1!.color,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          style: TextStyle(
            color: Theme.of(context).textTheme.headline1!.color,
            fontSize: 18.0,
          ),
          decoration: InputDecoration(
            prefixIcon: Text(
              '\+',
              style: TextStyle(
                color: Theme.of(context).textTheme.headline1!.color,
                fontSize: 18.0,
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
            enabledBorder: const UnderlineInputBorder(
              borderSide: const BorderSide(
                color: const Color.fromARGB(255, 78, 85, 98),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).accentColor,
                width: 2.0,
              ),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 6.0,
            ),
          ),
        ),
      ),
    );
  }

  void _handleCodeInput(String text) {
    if (text.isNotEmpty) {
      Country? country = context
          .read<SelectCountryProvider>()
          .findCountryByCode(int.parse(text));
      if (country != null)
        setState(() => _selectedCountryName = country.name);
      else
        setState(() => _selectedCountryName = 'Invalid country code');
      context.read<SelectCountryProvider>().selectedCountry = country;
    } else {
      setState(() => _selectedCountryName = 'Choose a country');
      context.read<SelectCountryProvider>().selectedCountry = null;
    }
  }

  Widget _buildPhoneInput() {
    return Expanded(
      flex: 4,
      child: Container(
        margin: const EdgeInsets.only(left: 9.0),
        child: SlideTransition(
          position: _phoneInputPosition,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              CustomPaint(painter: _maskPainter),
              TextField(
                controller: _phoneInputController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                onChanged: (_) {
                  _maskPainter.fill(_phoneInputController.text);
                },
                autofocus: true,
                cursorColor: Theme.of(context).textTheme.headline1!.color,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color,
                  fontSize: 18.0,
                ),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: const Color.fromARGB(255, 78, 85, 98),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 2.0,
                    ),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 6.0,
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
        height: 1.25,
        color: const Color.fromARGB(255, 125, 138, 147),
      ),
    );
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

    double charPositionX = 1.0;

    charPositionX += _kCharGap * text.replaceAll(' ', '').length -
        (_kSpaceWidth * ' '.allMatches(text).length);

    for (int i = text.length; i < mask.length; i++) {
      if (mask[i] != ' ') {
        Path path = Path();
        path.moveTo(charPositionX + (i * _kCharWidth), 0.0);
        path.lineTo(charPositionX + (i * _kCharWidth) + _kCharWidth, 0.0);
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
