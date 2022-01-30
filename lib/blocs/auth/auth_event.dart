abstract class AuthEvent {}

class AppLaunched extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final Map<String, dynamic>? authData;

  LoggedIn([this.authData]);
}

class SignedUp extends AuthEvent {
  final Map<String, dynamic> authData;

  SignedUp(this.authData);
}

class LoggedOut extends AuthEvent {}
