import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegram_clone_mobile/locator.dart';
import 'package:telegram_clone_mobile/models/chat.dart';
import 'package:telegram_clone_mobile/models/message.dart';
import 'package:telegram_clone_mobile/services/chat_service.dart';

import 'chat_viewmodel.dart';

class SavedMessagesViewModel extends ChatViewModel {
  SavedMessagesViewModel({
    required DocumentSnapshot<Chat> snapshot,
  }) : super(snapshot: snapshot);

  final ChatService _chatService = locator<ChatService>();

  late String _title;
  late List<DocumentSnapshot<Message>> _messages;

  String get title => _title;

  List<DocumentSnapshot<Message>> get messages => _messages;

  Future<void> initialize() async {
    _title = 'Saved Messages';
    _messages = await _getMessages();

    listenChatChanges();
  }

  Future<List<DocumentSnapshot<Message>>> _getMessages() async {
    return (await _chatService.getMessages(id: snapshot.id)).docs;
  }

  void listenChatChanges() {
    _chatService
        .onChatMessagesChanged(id: snapshot.id)
        .listen((messageSnapshots) {
      if (messageSnapshots.size > 0) {
        _messages = messageSnapshots.docs;
        notifyListeners();
      }
    });
  }
}
