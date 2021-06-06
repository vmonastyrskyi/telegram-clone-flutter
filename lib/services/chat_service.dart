import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegram_clone_mobile/models/chat.dart';
import 'package:telegram_clone_mobile/models/message.dart';

class ChatService {
  static const String _kCollectionName = 'chats';

  static FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference<Chat> _chatsRef =
      _db.collection(_kCollectionName).withConverter<Chat>(
            fromFirestore: (snapshot, _) => Chat.fromJson(snapshot.data()!),
            toFirestore: (chat, _) => chat.toJson(),
          );

  Stream<QuerySnapshot<Message>> onChatMessagesChanged({required String chatId}) {
    return _chatsRef
        .doc(chatId)
        .collection(ChatFields.Messages)
        .withConverter<Message>(
          fromFirestore: (snapshot, _) => Message.fromJson(snapshot.data()!),
          toFirestore: (message, _) => message.toJson(),
        )
        .snapshots();
  }

  Future<DocumentSnapshot<Chat>> getChatById({required String chatId}) async {
    return await _chatsRef.doc(chatId).get();
  }
}
