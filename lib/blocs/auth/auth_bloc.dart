import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../../foundation/utils/my_exception.dart';
import '../../generated/l10n.dart';
import '../../models/profile.dart';
import '../../resources/user_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc {
  final _authSubject = BehaviorSubject<AuthState>();
  final _userRepository = UserRepository();

  AuthBloc() {
    _init();
  }

  Stream<AuthState> get stream => _authSubject.stream;

  _init() {
    _authSubject.sink.add(Unauthenticated());
  }

  void add(AuthEvent event) {
    if (event is AppLaunched) {
      _handleAppLaunched();
      //
    } else if (event is LoggedIn) {
      _handleLoggedIn(event.authData);
      //
    } else if (event is SignedUp) {
      _handleSignedUp(event.authData);
      //
    } else if (event is LoggedOut) {
      _handleLoggedOut();
    }
  }

  _handleAppLaunched() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      // Có tài khoản vừa xác thực Firsebase Auth
      if (user != null) {
        // Là tài khoản vừa đăng ký (chưa set profile trên Firestore)
        if (_neededCreateAuthData != null) {
          _setProfile(user.uid, _neededCreateAuthData!);
        }
        // Là tài khoản vừa đăng nhập
        else {
          _authSubject.sink.add(AuthLoading());
          _fetchProfile(user.uid);
        }
      }
      // Có tài khoản vừa đăng xuất bằng Firebase Auth
      else {
        _authSubject.sink.add(Unauthenticated());
      }
    });
  }

  _handleLoggedIn(Map<String, dynamic>? authData) async {
    try {
      // Đăng nhập bằng Firebase Auth
      await _userRepository.login(authData!['email'], authData['password']);
    } on MyException catch (e) {
      _authSubject.sink.add(AuthFailure.login(e.message));
    }
  }

  // Tải dữ liệu người dùng từ Firestore
  _fetchProfile(String uid) async {
    final profile = await _userRepository.fetchProfile(uid);
    //TODO: fetch friends
    if (profile != null) {
      _authSubject.sink.add(Authenticated(profile, []));
    } else {
      _authSubject.sink.add(AuthFailure.login(S.current.user_data_not_found));
    }
  }

  Map<String, dynamic>?
      _neededCreateAuthData; // Lưu thông tin tài khoản cần được thiết lập trên Firestore
  _handleSignedUp(Map<String, dynamic> authData) async {
    Profile profile = authData['profile'];
    _neededCreateAuthData = authData;
    try {
      // Đăng ký tài khoản bằng Firebase Auth
      _userRepository.signUp(profile.email, authData['password']!);
    } on MyException catch (e) {
      _neededCreateAuthData = null;
      _authSubject.sink.add(AuthFailure.signup(e.message));
    }
  }

  _setProfile(String uid, Map<String, dynamic> authData) async {
    Profile profileWithoutUID = authData['profile']; // Chưa có UID
    Profile profile = profileWithoutUID.copyWith(uid: uid); // Gán UID
    Profile? profileAferUpdate = await _userRepository
        .updateProfile(authData); // Cập nhật dữ liệu người dùng lên Firestore

    // Do lỗi upload avatar hoặc profile
    if (profileAferUpdate == null) {
      _authSubject.sink.add(AuthFailure.signup(S.current.set_user_data_failed));
      // Xóa account ở Firebase Auth (Firebase Auth và Firestore độc lập)
      _userRepository.deleteCurrentUser();
    } else {
      _authSubject.sink.add(Authenticated.justSignedUp(profile));
    }
  }

  _handleLoggedOut() {
    _userRepository.logout();
  }
}

final authBloc = AuthBloc();
