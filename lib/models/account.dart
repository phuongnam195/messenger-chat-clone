import 'profile.dart';

class Account {
  Profile profile;
  List<String> friendIDs;

  Account(this.profile, this.friendIDs);

  // factory Account.fromMap(String id, Map<String, dynamic> map) {
  //   final friendIDs = <String>[];
  //   for (var e in map['friendIDs']) {
  //     friendIDs.add(e as String);
  //   }
  //   return Account(Profile.fromMap(id, map), friendIDs);
  // }

  bool addFriend(String friendId) {
    if (friendIDs.contains(friendId)) {
      return false;
    } else {
      friendIDs.add(friendId);
      return true;
    }
  }
}
