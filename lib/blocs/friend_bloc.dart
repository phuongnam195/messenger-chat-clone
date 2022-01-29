import 'package:rxdart/rxdart.dart';

import '../foundation/utils/misc.dart';
import '../resources/chat_repository.dart';
import '../models/message.dart';
import '../models/profile.dart';
import '../resources/friend_repository.dart';

class FriendBloc {
  final String _myId;
  final String _friendId;

  FriendBloc(this._myId, this._friendId);

  final _friendRepository = FriendRepository();
  final _chatRepository = ChatRepository();

  final _profileSubject = BehaviorSubject<Profile>();
  final _onlineSubject = BehaviorSubject<bool>();
  final _lastMessageSubject = BehaviorSubject<Message>();

  Stream<Profile> get profile => _profileSubject.stream;
  Stream<bool> get online => _onlineSubject.stream;
  Stream<Message> get lastMessage => _lastMessageSubject.stream;

  Profile? _oldProfile;
  bool? _oldOnline;

  // event: data changes from Firestore
  // state: friend's profile, online state, last message
  void streamProfileAndOnline() {
    _friendRepository.accountStream(_friendId).listen((map) {
      if (map == null) {
        print('<<FriendBloc-start()>>: map is null');
        return;
      }

      final newProfile = Profile.fromMap(_friendId, map);
      if (!newProfile.equals(_oldProfile)) {
        _profileSubject.sink.add(newProfile);
        _oldProfile = newProfile;
      }

      final newOnline = map['isOnline'];
      if (newOnline != _oldOnline) {
        _onlineSubject.sink.add(newOnline);
        _oldOnline = newOnline;
      }
    });
  }

  void streamLastMessage() {
    _chatRepository
        .messagesStream(combineID(_myId, _friendId))
        .listen((newMessages) {
      _lastMessageSubject.sink.add(newMessages.first);
    });
  }

  void dispose() {
    _profileSubject.close();
    _onlineSubject.close();
    _lastMessageSubject.close();
  }
}

class FriendBlocsCache {
  static final FriendBlocsCache instance = FriendBlocsCache._internal();
  FriendBlocsCache._internal();

  final _threshold = 30;
  final _cleanNumber = 10;

  final Map<String, FriendBloc> _cache = {};
  final List<String> _logKeys = [];

  FriendBloc get(String myId, String friendId) {
    final key = myId + friendId;
    if (!_cache.containsKey(key)) {
      _cache[key] = FriendBloc(myId, friendId);
      _cache[key]!.streamProfileAndOnline();
      _cache[key]!.streamLastMessage();
      print('<<FriendBlocsCache-get()>>: key = $key');
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
