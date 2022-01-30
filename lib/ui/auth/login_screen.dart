import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import 'widgets/login_card.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: screenHeight / 6.5,
                  child: _wxLogo(),
                ),
                SizedBox(height: screenHeight / 17),
                SizedBox(
                  height: screenHeight / 15,
                  child: _wxSubtitle(),
                ),
                SizedBox(height: screenHeight / 28),
                SizedBox(
                  height: screenHeight * 0.42,
                  child: LoginCard(context),
                ),
                SizedBox(height: screenHeight * 0.02),
                _wxForgot(context, screenHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _wxForgot(BuildContext context, double screenHeight) {
    return TextButton(
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
      style:
          TextButton.styleFrom(fixedSize: Size.fromHeight(screenHeight * 0.02)),
    );
  }

  Widget _wxSubtitle() {
    return FittedBox(
      child: Text(
        S.current.login_subtitle,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _wxLogo() => Image.asset('assets/images/logo_192.png');
}
