import 'package:cloud_firestore/cloud_firestore.dart';

import '../foundation/utils/misc.dart';
import '../models/message.dart';

class ChatRepository {
  final _chatsFirestore = FirebaseFirestore.instance.collection('chats');
  final _nFirstLoad = 15;
  final _nLoadMore = 10;

  bool _firstLoaded = true;

  Stream<List<Message>> messagesStream(String chatId) {
    var query = _chatsFirestore
        .doc(chatId)
        .collection('messages')
        .orderBy('time', descending: true);
    if (_firstLoaded) {
      query.limit(_nFirstLoad);
      _firstLoaded = false;
    }
    return query.snapshots().map((snapshot) => snapshot.docChanges
        .map((e) => Message.fromMap(e.doc.id, e.doc.data()!))
        .toList());
  }

  Future<List<Message>> loadMoreMessages(
      String chatId, Timestamp beforeTime) async {
    final snapshot = await _chatsFirestore
        .doc(chatId)
        .collection('messages')
        .orderBy('time', descending: true)
        .startAfter([beforeTime])
        .limit(_nLoadMore)
        .get();
    return snapshot.docs.map((e) => Message.fromMap(e.id, e.data())).toList();
  }

  Future<void> sendMessage(Message message, String receiverId) async {
    try {
      await _chatsFirestore
          .doc(combineID(message.sender, receiverId))
          .collection('messages')
          .doc(message.id)
          .set(message.toMap());
    } on FirebaseException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
  }
}
