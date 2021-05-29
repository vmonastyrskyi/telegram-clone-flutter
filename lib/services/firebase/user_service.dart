import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegram_clone_mobile/models/user_details.dart';

class UserService {
  static const String _kCollectionName = 'users';

  static FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference<UserDetails> _users = _db
      .collection(_kCollectionName)
      .withConverter<UserDetails>(
        fromFirestore: (snapshot, _) => UserDetails.fromJson(snapshot.data()!),
        toFirestore: (userDetails, _) => userDetails.toJson(),
      );

  Stream<DocumentSnapshot<UserDetails>> onUserChanged(
      {required String userId}) {
    return _users.doc(userId).snapshots();
  }

  Future<DocumentSnapshot<UserDetails>> getUserById(
      {required String userId}) async {
    return await _users.doc(userId).get();
  }

  Future<void> addUser({
    required String userId,
    required UserDetails details,
  }) async {
    return await _users.doc(userId).set(details);
  }
}
