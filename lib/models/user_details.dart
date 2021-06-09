import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsFields {
  static const String Username = 'username';
  static const String FirstName = 'first_name';
  static const String LastName = 'last_name';
  static const String PhoneNumber = 'phone_number';
  static const String Online = 'online';
  static const String Chats = 'chats';
  static const String SavedMessages = 'saved_messages';
}

class UserDetails {
  UserDetails({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.online,
    required this.chats,
  });

  final String username;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final bool online;
  final List<DocumentReference> chats;

  UserDetails.fromJson(Map<String, dynamic> json)
      : this(
          username: json[UserDetailsFields.Username] as String,
          firstName: json[UserDetailsFields.FirstName] as String,
          lastName: json[UserDetailsFields.LastName] as String,
          phoneNumber: json[UserDetailsFields.PhoneNumber] as String,
          online: json[UserDetailsFields.Online] as bool,
          chats: List<DocumentReference>.from(json[UserDetailsFields.Chats]),
        );

  Map<String, dynamic> toJson() {
    return {
      UserDetailsFields.Username: username,
      UserDetailsFields.FirstName: firstName,
      UserDetailsFields.LastName: lastName,
      UserDetailsFields.PhoneNumber: phoneNumber,
      UserDetailsFields.Online: online,
      UserDetailsFields.Chats: chats,
    };
  }
}
