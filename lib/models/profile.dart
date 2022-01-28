class Profile {
  final String id;
  final String email;
  String firstName;
  String lastName;
  String? avatarUrl;

  Profile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
  });

  String get fullname => firstName + ' ' + lastName;

  set avatarURL(String url) => avatarUrl = url;

  factory Profile.fromMap(String id, Map<String, dynamic> map) {
    return Profile(
      id: id,
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      avatarUrl: map['avatarUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'avatarUrl': avatarUrl,
      }..removeWhere((_, value) => value == null);

  bool equals(Profile? other) {
    if (other == null) return false;
    return id == other.id &&
        email == other.email &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        avatarUrl == other.avatarUrl;
  }
}
