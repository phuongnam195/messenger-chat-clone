// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../models/account.dart';
// import '../models/profile.dart';

// class AccountRepository {
//   final _usersFirestore = FirebaseFirestore.instance.collection('users');

//   // Cập nhật trạng thái online cho tài khoản [uid]
//   Future<void> setOnline(String uid, bool newState) async {
//     await _usersFirestore.doc(uid).update({'isOnline': newState});
//   }
// }
