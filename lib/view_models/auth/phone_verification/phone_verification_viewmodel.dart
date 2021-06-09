
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegram_clone_mobile/locator.dart';
import 'package:telegram_clone_mobile/services/auth_service.dart';
import 'package:telegram_clone_mobile/view_models/base_viewmodel.dart';

class PhoneVerificationViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();

  int? _resendToken;
  String? _verificationId;
  int _otpCodeLength = 6;

  String? get verificationId => _verificationId;

  int get otpCodeLength => _otpCodeLength;

  void signInWithPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    void Function(FirebaseAuthException)? verificationFailed,
    void Function(String)? codeAutoRetrievalTimeout,
  }) {
    _authService.signInWithPhoneNumber(
      phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: (verificationId, resendToken) {
        _resendToken = resendToken;
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      autoRetrievedSmsCodeForTesting: '123321',
      forceResendingToken: _resendToken,
    );
    _resendToken = null;
  }

  Future<bool> signInWithCredential(PhoneAuthCredential credential) async {
    try {
      await _authService.signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInWithCode(String code) async {
    try {
      if (verificationId == null) {
        return false;
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: code,
      );
      await _authService.signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }
}
