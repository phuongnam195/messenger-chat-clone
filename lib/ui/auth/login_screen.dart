import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../foundation/utils/my_dialog.dart';
import '../../foundation/utils/my_exception.dart';
import '../../foundation/utils/validator.dart';
import 'widgets/login_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Image _logo;
  bool _isLoaded = false;

  Future<bool> _onSubmit(String email, String password) async {
    try {
      if (Validator.email(email) == false) {
        throw MyException(S.current.invalid_email);
      }
      if (password.length < 6) {
        throw MyException(S.current.weak_password);
      }
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on MyException catch (e) {
      MyDialog.show(context, S.current.error, e.toString());
    } catch (e) {
      MyDialog.show(context, S.current.error, S.current.unknown_error);
    }
    return false;
  }

  @override
  void initState() {
    _logo = Image.asset(
      './assets/images/logo_192.png',
      fit: BoxFit.contain,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isLoaded) {
      precacheImage(_logo.image, context);
    }
    setState(() {
      _isLoaded = true;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: !_isLoaded
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: screenHeight / 6.5,
                        child: _logo,
                      ),
                      SizedBox(height: screenHeight / 17),
                      SizedBox(
                        height: screenHeight / 15,
                        child: FittedBox(
                          child: Text(
                            S.current.login_subtitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight / 28),
                      SizedBox(
                          height: screenHeight * 0.42,
                          child: LoginCard(_onSubmit)),
                      SizedBox(height: screenHeight * 0.02),
                      TextButton(
                        child: Text(
                          S.current.auth_forgot,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              // fontSize: 16,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          print('...');
                        },
                        style: TextButton.styleFrom(
                            fixedSize: Size.fromHeight(screenHeight * 0.02)),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
