import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/models/country.dart';
import 'package:telegram_clone_mobile/ui/router.dart';
import 'package:telegram_clone_mobile/ui/screens/auth/phone_verification/phone_verification_screen.dart';
import 'package:telegram_clone_mobile/ui/screens/auth/router.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/modal.dart';
import 'package:telegram_clone_mobile/util/curves/sine_curve.dart';
import 'package:telegram_clone_mobile/view_models/auth/input_phone/input_phone_viewmodel.dart';
import 'package:vibration/vibration.dart';

import 'strings.dart';

class InputPhoneScreen extends StatefulWidget {
  const InputPhoneScreen({Key? key}) : super(key: key);

  @override
  _InputPhoneScreenState createState() => _InputPhoneScreenState();
}

class _InputPhoneScreenState extends State<InputPhoneScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static final int _kVibrationDuration = 175;
  static final int _kShakeDuration = 350;

  late final AnimationController _phoneInputAnimationController;
  late final Animation<Offset> _phoneInputPosition;

  @override
  void initState() {
    super.initState();
    _phoneInputAnimationController = AnimationController(
      duration: Duration(milliseconds: _kShakeDuration),
      vsync: this,
    )..value = 1.0;
    _phoneInputPosition =
        Tween<Offset>(begin: Offset(0.0125, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: SineCurve(waves: 3)))
            .animate(_phoneInputAnimationController);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<InputPhoneViewModel>().loadSignInData();
    });
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<InputPhoneViewModel>().loadSignInData();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _phoneInputAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(InputPhoneStrings.kTitle),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 32.0,
        ),
        child: Column(
          children: <Widget>[
            _buildChooseCountryButton(),
            const SizedBox(height: 18.0),
            Row(
              children: <Widget>[
                _buildCodeInput(),
                _buildPhoneInput(),
              ],
            ),
            const SizedBox(height: 32.0),
            _buildHint(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final model = context.read<InputPhoneViewModel>();

          if (model.countryCodeInputController.text.isEmpty) {
            _showAlert(
              message: InputPhoneStrings.kChooseCountryAlertMessage,
            );
          } else if (!model.isValidCountryCode) {
            _showAlert(
              message: InputPhoneStrings.kInvalidCountryCodeAlertMessage,
            );
          } else if (model.phoneInputController.text.isEmpty) {
            Vibration.vibrate(duration: _kVibrationDuration);
            _phoneInputAnimationController.forward(from: 0.0);
          } else if (!model.phoneInputController.isValid()) {
            _showAlert(
              message: InputPhoneStrings.kInvalidPhoneNumberAlertMessage,
            );
          } else {
            final phoneNumber =
                '+${model.countryCodeInputController.text} ${model.phoneInputController.text}';
            final args = PhoneVerificationArgs(
              phoneNumber: phoneNumber,
            );
            final authenticated = await Navigator.of(context)
                .pushNamed<bool>(AuthRoutes.PhoneVerification, arguments: args);
            if (authenticated != null && authenticated) {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed(AppRoutes.Home);
              model.saveSignInData();
            }
          }
        },
        splashColor: Colors.white.withOpacity(0.25),
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildChooseCountryButton() {
    return Selector<InputPhoneViewModel, String>(
      selector: (context, model) => model.selectedCountryPlaceholder,
      builder: (context, selectedCountryPlaceholder, _) {
        return InkWell(
          onTap: () async {
            final country = await Navigator.of(context)
                .pushNamed<Country>(AuthRoutes.SelectCountry);
            if (country != null) {
              context
                  .read<InputPhoneViewModel>()
                  .selectCountryByCode(country.code.toString());
            }
          },
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
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 201, 212, 216),
                  ),
                ),
                isDense: true,
                hintText: selectedCountryPlaceholder,
                hintStyle: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color,
                  fontSize: 18.0,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCodeInput() {
    final model = context.read<InputPhoneViewModel>();

    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.only(right: 9.0),
        child: TextField(
          onChanged: model.selectCountryByCode,
          inputFormatters: [
            LengthLimitingTextInputFormatter(4),
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
          ],
          controller: model.countryCodeInputController,
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
              borderSide: BorderSide(
                color: Color.fromARGB(255, 78, 85, 98),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).accentColor,
                width: 2.0,
              ),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    final model = context.read<InputPhoneViewModel>();

    return Expanded(
      flex: 4,
      child: Container(
        margin: const EdgeInsets.only(left: 9.0),
        child: SlideTransition(
          position: _phoneInputPosition,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              CustomPaint(painter: model.maskPainter),
              TextField(
                controller: model.phoneInputController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                onChanged: (_) => model.fillMask(),
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
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
      InputPhoneStrings.kHintText,
      style: TextStyle(
        height: 1.25,
        color: Color.fromARGB(255, 125, 138, 147),
      ),
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
          title: InputPhoneStrings.kAlertTitle,
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
