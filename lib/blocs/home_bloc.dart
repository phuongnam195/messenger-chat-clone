import 'package:rxdart/rxdart.dart';

import '../models/profile.dart';
import '../resources/user_repository.dart';

class HomeBloc {
  HomeBloc();

  final _userRepository = UserRepository();

  final _pageSubject = PublishSubject<int>();
  final _peopleSubject = BehaviorSubject<List<Profile>>();

  Stream<int> get page => _pageSubject.stream;
  Stream<List<Profile>> get people => _peopleSubject.stream;

  void moveToPage(int index) {
    _pageSubject.sink.add(index);
  }

  void fetchPeople() async {
    final users = await _userRepository.fetchAllUsers();
    users.sort((a, b) => a.fullname.compareTo(b.fullname));
    _peopleSubject.sink.add(users);
  }
}

final homeBloc = HomeBloc();
