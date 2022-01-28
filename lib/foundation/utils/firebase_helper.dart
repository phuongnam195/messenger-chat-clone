import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../generated/l10n.dart';
import '../../models/account.dart';
import '../../models/profile.dart';
import 'my_exception.dart';

class FirebaseHelper {
  static final auth = FirebaseAuth.instance;
  static final users = FirebaseFirestore.instance.collection('users');

  static String? get currentUID => auth.currentUser?.uid;

  static Future<User?> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
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

  static Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
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

  static Future<Account?> createAccount({
    required Profile tempProfile,
    File? avatarFile,
  }) async {
    if (avatarFile != null) {
      final avatarUrl = await FirebaseHelper.uploadFile(
          'avatars/${tempProfile.email}', avatarFile);
      if (avatarUrl == null) {
        return null;
      } else {
        tempProfile.avatarURL = avatarUrl;
      }
    }
    final profile = tempProfile;

    try {
      await users.doc(profile.id).set(profile.toMap());
    } catch (e) {
      FirebaseStorage.instance.ref('avatars/${profile.email}').delete();
      return null;
    }

    return Account(profile, []);
  }

  static Future<String?> uploadFile(String refPath, File file) async {
    try {
      final uploadTask =
          await FirebaseStorage.instance.ref(refPath).putFile(file);
      return uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print('<<FirebaseHelper-uploadFile()>>: Failed to upload');
    }
    return null;
  }
}
