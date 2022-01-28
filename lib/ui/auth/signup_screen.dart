import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../foundation/utils/firebase_helper.dart';
import '../../models/profile.dart';
import '../../foundation/utils/my_dialog.dart';
import '../../generated/l10n.dart';
import '../../foundation/utils/my_exception.dart';
import '../../foundation/utils/validator.dart';
import 'widgets/signup_card.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Future<bool> _onSubmit(Profile info, String password, File? imageFile) async {
    try {
      if (Validator.email(info.email) == false) {
        throw MyException(S.current.invalid_email);
      }
      if (password.length < 6) {
        throw MyException(S.current.weak_password);
      }

      await FirebaseHelper.signUp(info.email, password);
      final account = await FirebaseHelper.createAccount(
          tempProfile: info, avatarFile: imageFile);
      if (account == null) {
        FirebaseAuth.instance.currentUser!.delete();
      }
      Navigator.pop(context);
      return true;
    } on MyException catch (error) {
      MyDialog.show(context, S.current.error, error.toString());
    } catch (error) {
      MyDialog.show(context, S.current.error, S.current.unknown_error);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final initInfoFromLogin =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(237, 240, 245, 1),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Facebook'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignUpCard(
                    initEmail: initInfoFromLogin['email'],
                    initPassword: initInfoFromLogin['password'],
                    onSubmit: _onSubmit,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    child: Text(
                      S.current.ask_signup,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
