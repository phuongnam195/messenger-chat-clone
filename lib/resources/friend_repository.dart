import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRepository {
  final _usersFirestore = FirebaseFirestore.instance.collection('users');
  final _chatsFirestore = FirebaseFirestore.instance.collection('chats');

  Stream<Map<String, dynamic>?> accountStream(String uid) {
    return _usersFirestore.doc(uid).snapshots().map((event) => event.data());
  }

  Stream<String> themeStream(String uid) {
    return _chatsFirestore
        .doc(uid)
        .snapshots()
        .map((event) => event.data()!['theme']);
  }
}
