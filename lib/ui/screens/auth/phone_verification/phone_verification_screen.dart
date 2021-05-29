import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_clone_mobile/constants/shared_preferences.dart';
import 'package:telegram_clone_mobile/locator.dart';
import 'package:telegram_clone_mobile/provider/select_country_provider.dart';
import 'package:telegram_clone_mobile/services/firebase/auth_service.dart';
import 'package:telegram_clone_mobile/ui/router.dart';
import 'package:telegram_clone_mobile/ui/screens/auth/phone_verification/widgets/otp_form.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/appbar_icon_button.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/modal.dart';
import 'package:telegram_clone_mobile/util/curves/sine_curve.dart';
import 'package:vibration/vibration.dart';

class PhoneVerificationArgs {
  final String localPhoneNumber;
  final String formattedPhoneNumber;

  PhoneVerificationArgs({
    required this.localPhoneNumber,
    required this.formattedPhoneNumber,
  });
}

class PhoneVerificationScreen extends StatefulWidget {
  final String localPhoneNumber;
  final String formattedPhoneNumber;

  const PhoneVerificationScreen({
    Key? key,
    required this.localPhoneNumber,
    required this.formattedPhoneNumber,
  }) : super(key: key);

  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen>
    with SingleTickerProviderStateMixin {
  static const String _kOtpFormInputPrefix = 'otpFormInput';
  static const int _kVibrationDuration = 175;
  static const int _kShakeDuration = 350;
  static const int _kOtpCodeLength = 6;

  final GlobalKey<OtpFormState> _otpFormKey = GlobalKey();

  final AuthService _authService = services.get<AuthService>();

  late final AnimationController _otpInputAnimationController;
  late final Animation<Offset> _otpInputPosition;

  int? resendToken;
  String? verificationId;

  @override
  void initState() {
    super.initState();
    _otpInputAnimationController = AnimationController(
      duration: Duration(milliseconds: _kShakeDuration),
      vsync: this,
    )..value = 1.0;
    _otpInputPosition = Tween(begin: Offset(0.0125, 0.0), end: Offset.zero)
        .chain(CurveTween(curve: SineCurve(waves: 3)))
        .animate(_otpInputAnimationController);
    _signInWithPhoneNumber();
  }

  @override
  void dispose() {
    _otpInputAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.formattedPhoneNumber),
        leading: AppBarIconButton(
          icon: Icons.arrow_back,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 32.0,
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(
              width: 64.0,
              height: 64.0,
              child: const Image(
                image: const AssetImage('assets/images/phone_sms.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Check your Phone messages',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.headline1!.color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'We\'ve sent an SMS with code to your device.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline2!.color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: SlideTransition(
                position: _otpInputPosition,
                child: OtpForm(
                  key: _otpFormKey,
                  inputPrefix: _kOtpFormInputPrefix,
                  length: _kOtpCodeLength,
                  onSubmit: (code) async {
                    if (verificationId != null) {
                      print('Sign in with code $code');
                      final credential = PhoneAuthProvider.credential(
                          verificationId: verificationId!, smsCode: code);
                      await _authService.signInWithCredential(credential);
                      await _saveInputsData();

                      Navigator.of(context, rootNavigator: true)
                          .pushReplacementNamed(AppRoutes.Home);
                    } else {
                      print('Invalid verificationId.');
                      await _showAlert(
                        title: 'Telegram',
                        message: 'Invalid code, please try again.',
                      );
                      _otpFormKey.currentState!.reset();
                    }
                  },
                  onEditingComplete: (code) async {
                    if (code.isEmpty) {
                      Vibration.vibrate(duration: _kVibrationDuration);
                      _otpInputAnimationController.forward(from: 0.0);
                    } else if (code.length < _kOtpCodeLength) {
                      await _showAlert(
                        title: 'Telegram',
                        message: 'Invalid code, please try again.',
                      );
                      _otpFormKey.currentState!.reset();
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: GestureDetector(
                onTap: _signInWithPhoneNumber,
                child: Text(
                  'Re-send an SMS with code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveInputsData() async {
    final selectedCountry =
        context.read<SelectCountryProvider>().selectedCountry;
    if (selectedCountry != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          SharedPrefsConstants.kSelectedCountry, jsonEncode(selectedCountry));
      prefs.setString(
          SharedPrefsConstants.kPhoneNumber, widget.localPhoneNumber);
    }
  }

  void _signInWithPhoneNumber() {
    _authService.signInWithPhoneNumber(
      widget.formattedPhoneNumber,
      verificationCompleted: (credential) async {
        if (mounted) {
          if (credential.smsCode != null) {
            print('Auto verification completed.');
            _otpFormKey.currentState!.fillAndDisable(credential.smsCode!);
            await _authService.signInWithCredential(credential);
            Navigator.of(context, rootNavigator: true)
                .pushReplacementNamed(AppRoutes.Home);
          }
        }
      },
      verificationFailed: (error) {
        if (error.code == 'invalid-phone-number') {
          if (mounted) {
            print('The provided phone number is not valid.');
            Navigator.of(context).pop();
            _showAlert(
              title: 'Telegram',
              message: 'The provided phone number is not valid.',
            );
          }
        }
      },
      codeSent: (verificationId, resendToken) {
        if (mounted) {
          print('Code has been sent to the device.');
          this.resendToken = resendToken;
          this.verificationId = verificationId;
        }
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        if (mounted) {
          print('Code expired, please retry login.');
          Navigator.of(context).pop();
          _showAlert(
            title: 'Telegram',
            message: 'Code expired, please retry login.',
          );
        }
      },
      forceResendingToken: resendToken,
    );
    this.resendToken = null;
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
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
