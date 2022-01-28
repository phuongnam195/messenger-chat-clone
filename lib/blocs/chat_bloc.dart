import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../foundation/utils/misc.dart';
import '../models/message.dart';
import '../resources/chat_repository.dart';

class Messages {
  final List<Message> list;
  final bool isOld; // false = isNew

  Messages(this.list, {this.isOld = false});
}

class ChatBloc {
  final String _chatId;

  ChatBloc(this._chatId);

  final _chatRepository = ChatRepository();

  final _messagesSubject = ReplaySubject<Messages>();
  final _typingSubject = PublishSubject<bool>();

  Stream<Messages> get messages => _messagesSubject.stream;
  Stream<bool> get typing => _typingSubject.stream;

  // event: messages stream from Firestore
  // state: update new messages
  void streamMessages() {
    _chatRepository.messagesStream(_chatId).listen((newMessages) {
      print('<<ChatBloc-listenMessages(): ${newMessages.length}');
      _messagesSubject.sink.add(Messages(newMessages));
    });
  }

  // event: pull to load more
  // state: load more old messages
  void loadMoreMessage(Timestamp beforeTime) async {
    final oldMessages =
        await _chatRepository.loadMoreMessages(_chatId, beforeTime);
    print('<<ChatBloc-loadMoreMessage(): ${oldMessages.length}');
    _messagesSubject.sink.add(Messages(oldMessages, isOld: true));
  }

  // event: TextField has text
  // state: true/false
  void setTypingListener(TextEditingController controller) {
    bool hasText = false;
    controller.addListener(() {
      if (!(hasText ^ controller.text.isEmpty)) {
        hasText = !hasText;
        _typingSubject.sink.add(hasText);
      }
    });
  }

  void sendMessage(Message message, String receiverId) {
    _chatRepository.sendMessage(message, receiverId);
  }

  void dispose() {
    _messagesSubject.close();
  }
}

class ChatBlocsCache {
  static final ChatBlocsCache instance = ChatBlocsCache._internal();
  ChatBlocsCache._internal();

  final _threshold = 10;
  final _cleanNumber = 5;

  final Map<String, ChatBloc> _cache = {};
  final List<String> _logKeys = [];

  ChatBloc get(String myId, String friendId) {
    final key = combineID(myId, friendId);
    if (!_cache.containsKey(key)) {
      _cache[key] = ChatBloc(key);
      _cache[key]!.streamMessages();
      _logKeys.add(key);
      if (_cache.length > _threshold) {
        _clean();
      }
    }
    return _cache[key]!;
  }

  void _clean() {
    for (int i = 0; i < _cleanNumber; i++) {
      _cache[_logKeys[i]]!.dispose();
      _cache.remove(_logKeys[i]);
    }
    _logKeys.removeRange(0, _cleanNumber);
  }

  void release() {
    for (String key in _logKeys) {
      _cache[key]!.dispose();
    }
    _cache.clear();
    _logKeys.clear();
  }
}
