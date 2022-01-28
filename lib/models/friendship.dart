enum FriendshipType {
  accepted,
  requesting,
  // blocked,
  none,
}

class Friendship {
  FriendshipType type;
  String? requesterID;
  String? accepterID;

  Friendship(this.type, [this.requesterID, this.accepterID]);

  factory Friendship.fromMap(Map<String, dynamic> map) => Friendship(
      mapTypeStrToEnum(map['type']), map['requesterID'], map['accepterID']);
}

FriendshipType mapTypeStrToEnum(String type) {
  switch (type) {
    case 'accepted':
      return FriendshipType.accepted;
    case 'requesting':
      return FriendshipType.requesting;
    default:
      return FriendshipType.none;
  }
}
