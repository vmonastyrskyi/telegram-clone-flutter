import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegram_clone_mobile/models/user_details.dart';

class UserService {
  static const String _kCollectionName = 'users';

  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference<UserDetails> _usersRef = _db
      .collection(_kCollectionName)
      .withConverter<UserDetails>(
        fromFirestore: (snapshot, _) => UserDetails.fromJson(snapshot.data()!),
        toFirestore: (userDetails, _) => userDetails.toJson(),
      );

  Stream<DocumentSnapshot<UserDetails>> onUserChanged(
      {required String userId}) {
    return _usersRef.doc(userId).snapshots();
  }

  Future<DocumentSnapshot<UserDetails>> getUserById(
      {required String userId}) async {
    return await _usersRef.doc(userId).get();
  }

  Future<void> addUser(
      {required String userId, required UserDetails details}) async {
    return await _usersRef.doc(userId).set(details);
  }

  Future<List<DocumentReference>> getChats() async {
    final userId = _auth.currentUser!.uid;
    final userDetailsSnap = await _usersRef.doc(userId).get();

    if (userDetailsSnap.exists && userDetailsSnap.data() != null) {
      return userDetailsSnap.data()!.chats;
    }

    return [];
  }

  Future<void> setOnlineStatus(bool online) async {
    final userId = _auth.currentUser!.uid;
    return await _usersRef
        .doc(userId)
        .update({UserDetailsFields.Online: online});
  }
}
