import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/appbar_icon_button.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/modal.dart';
import 'package:telegram_clone_mobile/util/curves/sine_curve.dart';
import 'package:telegram_clone_mobile/view_models/auth/phone_verification/phone_verification_viewmodel.dart';
import 'package:vibration/vibration.dart';

import 'strings.dart';
import 'widgets/otp_form.dart';

class PhoneVerificationArgs {
  PhoneVerificationArgs({
    required this.phoneNumber,
  });

  final String phoneNumber;
}

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  final String phoneNumber;

  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen>
    with SingleTickerProviderStateMixin {
  static const String _kOtpFormInputPrefix = 'otpFormInput';
  static const int _kVibrationDuration = 175;
  static const int _kShakeDuration = 350;

  final GlobalKey<OtpFormState> _otpFormKey = GlobalKey();

  late final AnimationController _otpInputAnimationController;
  late final Animation<Offset> _otpInputPosition;

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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _signInWithPhoneNumber();
    });
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
        leading: AppBarIconButton(
          icon: Icons.arrow_back,
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.phoneNumber),
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
              child: Image(
                image: AssetImage('assets/images/phone_sms.png'),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              PhoneVerificationStrings.kHintText1,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.headline1!.color,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              PhoneVerificationStrings.kHintText2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.headline2!.color,
              ),
            ),
            const SizedBox(height: 32.0),
            Consumer<PhoneVerificationViewModel>(
              builder: (context, model, _) {
                return SlideTransition(
                  position: _otpInputPosition,
                  child: OtpForm(
                    key: _otpFormKey,
                    inputPrefix: _kOtpFormInputPrefix,
                    length: model.otpCodeLength,
                    onSubmit: (code) async {
                      print(code);
                      if (await model.signInWithCode(code)) {
                        Navigator.of(context).pop(true);
                      } else {
                        await _showAlert(
                          message:
                              PhoneVerificationStrings.kInvalidCodeAlertMessage,
                        );
                        _otpFormKey.currentState!.reset();
                      }
                    },
                    onEditingComplete: (code) async {
                      if (code.isEmpty) {
                        Vibration.vibrate(duration: _kVibrationDuration);
                        _otpInputAnimationController.forward(from: 0.0);
                      } else if (code.length < model.otpCodeLength) {
                        await _showAlert(
                          message:
                              PhoneVerificationStrings.kInvalidCodeAlertMessage,
                        );
                        _otpFormKey.currentState!.reset();
                      }
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 40.0),
            GestureDetector(
              onTap: () => _signInWithPhoneNumber(),
              child: Text(
                PhoneVerificationStrings.kReSendSMSButtonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signInWithPhoneNumber() {
    final model = context.read<PhoneVerificationViewModel>();

    print(widget.phoneNumber.replaceAll(' ', ''));

    model.signInWithPhoneNumber(
      phoneNumber: widget.phoneNumber.replaceAll(' ', ''),
      verificationCompleted: (credential) async {
        print('CREDENTIALS $credential');

        if (credential.smsCode != null) {
          if (mounted) {
            _otpFormKey.currentState!.fillAndDisable(credential.smsCode!);
            if (await model.signInWithCredential(credential)) {
              Navigator.of(context).pop(true);
            } else {
              _otpFormKey.currentState!.enabled = true;
            }
          }
        }
      },
      verificationFailed: (error) {
        if (error.code == 'invalid-phone-number') {
          if (mounted) {
            Navigator.of(context).pop();
            _showAlert(
              message: PhoneVerificationStrings.kInvalidPhoneNumberAlertMessage,
            );
          }
        }
      },
      codeAutoRetrievalTimeout: (verificationId) {
        if (mounted) {
          Navigator.of(context).pop();
          _showAlert(
            message: PhoneVerificationStrings.kCodeExpiredAlertMessage,
          );
        }
      },
    );
  }

  Future<void> _showAlert({
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
          title: PhoneVerificationStrings.kAlertTitle,
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
