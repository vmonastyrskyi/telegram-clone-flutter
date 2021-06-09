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
      {required String id}) {
    return _usersRef.doc(id).snapshots();
  }

  Future<DocumentSnapshot<UserDetails>> getUserById(
      {required String id}) async {
    return await _usersRef.doc(id).get();
  }

  Future<void> addUser({
    required String id,
    required UserDetails details,
  }) async {
    return await _usersRef.doc(id).set(details);
  }

  Future<List<DocumentReference>> getChats() async {
    final userId = _auth.currentUser!.uid;
    final userSnapshot = await _usersRef.doc(userId).get();

    if (userSnapshot.exists && userSnapshot.data() != null) {
      return userSnapshot.data()!.chats;
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
