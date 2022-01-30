// import 'package:rxdart/rxdart.dart';

// import '../foundation/utils/firebase_helper.dart';
// import '../models/account.dart';
// import '../resources/account_repository.dart';

// class AccountBloc {
//   final _repository = AccountRepository();
//   final _currentAccountSubject = PublishSubject<Account>();

//   Stream<Account> get currentAccount => _currentAccountSubject.stream;

//   void fetchAccount() async {
//     final uid = FirebaseHelper.currentUID;
//     if (uid == null) {
//       print('<<AccountBloc-fetchAccount(): UID is null');
//       return;
//     }
//     final account = await _repository.fetchAccount(uid);
//     if (account == null) {
//       print('<<AccountBloc-fetchAccount(): Account is null');
//       return;
//     }
//     _currentAccountSubject.sink.add(account);
//   }

//   void dispose() {
//     _currentAccountSubject.close();
//   }
// }

// final accountBloc = AccountBloc();
