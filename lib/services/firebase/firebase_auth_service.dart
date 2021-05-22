import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  Future<void> signInWithPhoneNumber(
    String phoneNumber, {
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    void Function(String)? codeAutoRetrievalTimeout,
    String? autoRetrievedSmsCodeForTesting,
    int? forceResendingToken,
  }) async {
    return await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout ?? (verificationId) {},
      autoRetrievedSmsCodeForTesting: autoRetrievedSmsCodeForTesting,
      timeout: Duration(seconds: 30),
      forceResendingToken: forceResendingToken,
    );
  }

  Future<UserCredential> signInWithCredentials(
      PhoneAuthCredential credential) async {
    return await _auth.signInWithCredential(credential);
  }

  Stream<User?> get onAuthStateChanged {
    return _auth.authStateChanges();
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
