class Profile {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String? avatarUrl;

  Profile({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
  });

  Profile.withoutUID({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
  }) : uid = '';

  String get fullname => firstName + ' ' + lastName;

  factory Profile.fromMap(String uid, Map<String, dynamic> map) => Profile(
        uid: uid,
        email: map['email'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        avatarUrl: map['avatarUrl'],
      );

  Map<String, dynamic> toMap() => {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'avatarUrl': avatarUrl,
      }..removeWhere((_, value) => value == null);

  Profile copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? avatarUrl,
  }) =>
      Profile(
          uid: uid ?? this.uid,
          email: email ?? this.email,
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          avatarUrl: avatarUrl ?? this.avatarUrl);

  bool equals(Profile? other) {
    if (other == null) return false;
    return uid == other.uid &&
        email == other.email &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        avatarUrl == other.avatarUrl;
  }
}
