import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper {
  static final _storage = FirebaseStorage.instance;

  static Future<String?> uploadFile(String refPath, File file) async {
    try {
      final uploadTask = await _storage.ref(refPath).putFile(file);
      return uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print('<<FirebaseHelper-uploadFile()>>: Failed to upload');
    }
    return null;
  }

  static Future<String?> deleteFile(String refPath) async {
    _storage.ref(refPath).delete();
  }
}
