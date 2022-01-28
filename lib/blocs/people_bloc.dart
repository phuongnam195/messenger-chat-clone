import 'package:rxdart/rxdart.dart';

import '../models/profile.dart';
import '../resources/user_repository.dart';

class HomeBloc {
  HomeBloc();

  final _userRepository = UserRepository();

  final _peopleSubject = BehaviorSubject<List<Profile>>();

  Stream<List<Profile>> get people => _peopleSubject.stream;

  void fetchPeople() async {
    final users = await _userRepository.fetchAll();
    users.sort((a, b) => a.fullname.compareTo(b.fullname));
    _peopleSubject.sink.add(users);
  }

  void addFriend(String uid) async {
    users.
  }
}

final peopleBloc = HomeBloc();
