import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger_chat_clone/models/friendship.dart';

class FriendshipRepository {
  final _usersFirestore = FirebaseFirestore.instance.collection('users');
  final _friendshipsFirestore = FirebaseFirestore.instance.collection('friendships');

  Stream<List<Friendship>> listenFriendshipOfUser(String uid) {
    return _usersFirestore.
  }
}
