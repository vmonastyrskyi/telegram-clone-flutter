import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFields {
  static const String Type = 'type';
  static const String MessageCounter = 'message_counter';
  static const String HistoryCleared = 'history_cleared';
  static const String Users = 'users';
  static const String Messages = 'messages';
}

class ChatType {
  static const String SavedMessages = 'saved_messages';
  static const String Dialog = 'dialog';
  static const String Group = 'group';
}

class Chat {
  Chat({
    required this.type,
    required this.messageCounter,
    required this.historyCleared,
    required this.users,
  });

  final String type;
  final int messageCounter;
  final bool historyCleared;
  final List<DocumentReference> users;

  Chat.fromJson(Map<String, dynamic> json)
      : this(
          type: json[ChatFields.Type] as String,
          messageCounter: json[ChatFields.MessageCounter] as int,
          historyCleared: json[ChatFields.HistoryCleared] as bool,
          users: List<DocumentReference>.from(json[ChatFields.Users]),
        );

  Map<String, dynamic> toJson() {
    return {
      ChatFields.Type: type,
      ChatFields.MessageCounter: messageCounter,
      ChatFields.HistoryCleared: historyCleared,
      ChatFields.Users: users,
    };
  }
}
