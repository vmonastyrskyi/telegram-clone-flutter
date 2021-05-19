import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  Future<void> signInWithPhoneNumber(
    String phoneNumber,
    Function(PhoneAuthCredential) verificationCompleted,
    Function(FirebaseAuthException) verificationFailed,
    Function(String, int?) codeSent,
    Function(String) codeAutoRetrievalTimeout,
  ) async {
    return await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted:
          verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout:
          codeAutoRetrievalTimeout,
    );
  }

  Stream<User?> get onAuthStateChanged {
    return _auth.authStateChanges();
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
