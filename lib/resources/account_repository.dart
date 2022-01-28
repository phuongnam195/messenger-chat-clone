import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/account.dart';
import '../models/profile.dart';

class AccountRepository {
  final _accountsFirestore = FirebaseFirestore.instance.collection('accounts');

  // Lấy dữ liệu của tài khoản hiện tại từ Firebase
  Future<Account?> fetchAccount(String uid) async {
    final snapshot = await _accountsFirestore.doc(uid).get();
    final map = snapshot.data();

    if (map == null) {
      print(
          '<<AccountRepository-fetchProfile()>>: No data for this account ($uid)');
      //TODO: throw exception
      return null;
    }

    final profile = Profile.fromMap(uid, map);
    var account = Account(profile, []);
    if (map['friendIDs'] != null) {
      for (var e in map['friendIDs']) {
        String friendId = e as String;
        account.addFriend(friendId);
      }
    }

    return account;
  }

  // Cập nhật trạng thái online cho tài khoản [uid]
  Future<void> setOnline(String uid, bool newState) async {
    await _accountsFirestore.doc(uid).update({'isOnline': newState});
  }
}
