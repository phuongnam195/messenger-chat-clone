import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/profile.dart';

class UserRepository {
  final _usersFirestore = FirebaseFirestore.instance.collection('users');

  Future<List<Profile>> fetchAll() async {
    final query = await _usersFirestore.get();
    return query.docs.map((e) => Profile.fromMap(e.id, e.data())).toList();
  }
}
