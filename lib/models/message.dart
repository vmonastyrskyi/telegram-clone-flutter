import 'package:cloud_firestore/cloud_firestore.dart';

class MessageFields {
  static const String Owner = 'owner';
  static const String Text = 'text';
  static const String CreatedAt = 'created_at';
  static const String UpdatedAt = 'updated_at';
  static const String Edited = 'edited';
  static const String Read = 'read';
}

class Message {
  Message({
    required this.owner,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.edited,
    required this.read,
  });

  final DocumentReference owner;
  final String text;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final bool edited;
  final bool read;

  Message.fromJson(Map<String, dynamic> json)
      : this(
          owner: json[MessageFields.Owner] as DocumentReference,
          text: json[MessageFields.Text] as String,
          createdAt: json[MessageFields.CreatedAt] as Timestamp,
          updatedAt: json[MessageFields.UpdatedAt] as Timestamp,
          edited: json[MessageFields.Edited] as bool,
          read: json[MessageFields.Read] as bool,
        );

  Map<String, dynamic> toJson() {
    return {
      MessageFields.Owner: owner,
      MessageFields.Text: text,
      MessageFields.CreatedAt: createdAt,
      MessageFields.UpdatedAt: updatedAt,
      MessageFields.Edited: edited,
      MessageFields.Read: read,
    };
  }
}
