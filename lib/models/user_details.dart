class UserDetails {
  UserDetails({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.onlineStatus,
  });

  final String username;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final bool onlineStatus;

  UserDetails.fromJson(Map<String, dynamic> json)
      : this(
          username: json['username'] as String,
          firstName: json['first_name'] as String,
          lastName: json['last_name'] as String,
          phoneNumber: json['phone_number'] as String,
          onlineStatus: json['online_status'] as bool,
        );

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'online_status': onlineStatus,
    };
  }
}
