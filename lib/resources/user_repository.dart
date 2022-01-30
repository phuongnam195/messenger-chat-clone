import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_chat_clone/foundation/utils/validator.dart';

import '../foundation/utils/firebase_helper.dart';
import '../generated/l10n.dart';
import '../foundation/utils/my_exception.dart';
import '../models/profile.dart';

class UserRepository {
  final _auth = FirebaseAuth.instance;
  final _usersFirestore = FirebaseFirestore.instance.collection('users');

  Future<User?> login(String email, String password) async {
    if (Validator.email(email) == false) {
      throw MyException(S.current.invalid_email);
    }
    if (password.length < 6) {
      throw MyException(S.current.weak_password);
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw MyException(S.current.user_not_found);
        case 'wrong-password':
          throw MyException(S.current.wrong_password);
        default:
          throw MyException(
              S.current.unknown_error + '\n(firebase-auth: ${e.code})');
      }
    } catch (e) {
      throw MyException(S.current.unknown_error);
    }
  }

  Future<User?> signUp(String email, String password) async {
    if (Validator.email(email) == false) {
      throw MyException(S.current.invalid_email);
    }
    if (password.length < 6) {
      throw MyException(S.current.weak_password);
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw MyException(S.current.weak_password);
        case 'email-already-in-use':
          throw MyException(S.current.email_already_in_use);
        default:
          throw MyException(
              S.current.unknown_error + '\n(firebase-auth: ${e.code})');
      }
    } catch (error) {
      throw MyException(S.current.unknown_error);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<Profile?> updateProfile(Map data) async {
    Profile profile = data['profile'];
    File? avatarFile = data['avatarFile'];
    if (avatarFile != null) {
      final avatarUrl = await FirebaseHelper.uploadFile(
          'avatars/${profile.email}', avatarFile);
      if (avatarUrl == null) {
        return null;
      } else {
        profile = profile.copyWith(avatarUrl: avatarUrl);
      }
    }

    try {
      await _usersFirestore.doc(profile.uid).set(profile.toMap());
    } catch (e) {
      FirebaseHelper.deleteFile('avatars/${profile.email}');
      return null;
    }

    return profile;
  }

  Future<void> deleteCurrentUser([bool includeData = false]) async {
    if (_auth.currentUser != null) {
      _auth.currentUser!.delete();
    }

    //TODO: includeData
  }

  Future<Profile?> fetchProfile(String uid) async {
    final snapshot = await _usersFirestore.doc(uid).get();
    final map = snapshot.data();

    if (map == null) {
      print(
          '<<AccountRepository-fetchProfile()>>: No data for this account ($uid)');
      //TODO: throw exception
      return null;
    }

    final profile = Profile.fromMap(uid, map);
    return profile;
  }

  Future<List<Profile>> fetchAllUsers() async {
    final query = await _usersFirestore.get();
    return query.docs.map((e) => Profile.fromMap(e.id, e.data())).toList();
  }
}
