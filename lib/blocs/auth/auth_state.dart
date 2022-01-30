import '../../models/profile.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  final Profile profile;
  final List<String> friendIDs;

  Authenticated(this.profile, this.friendIDs);
  Authenticated.justSignedUp(this.profile) : friendIDs = [];
}

class AuthFailure extends AuthState {
  final int code;
  final String message;

  AuthFailure.login(this.message) : code = _codeLoginFailed;
  AuthFailure.signup(this.message) : code = _codeSignUpFailed;

  static const int _codeLoginFailed = 1;
  static const int _codeSignUpFailed = 2;
}
