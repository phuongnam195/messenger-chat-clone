import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import 'widgets/login_card.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  final loginCard = const LoginCard();

  @override
  Widget build(BuildContext context) {
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
                Builder(
                  builder: (context) {
                    final screenHeight = MediaQuery.of(context).size.height;
                    return SizedBox(
                      height: screenHeight / 6.5,
                      child: _wxLogo(),
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    final screenHeight = MediaQuery.of(context).size.height;
                    return SizedBox(height: screenHeight / 17);
                  },
                ),
                Builder(
                  builder: (context) {
                    final screenHeight = MediaQuery.of(context).size.height;
                    return SizedBox(
                      height: screenHeight / 15,
                      child: _wxSubtitle(),
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    final screenHeight = MediaQuery.of(context).size.height;
                    return SizedBox(height: screenHeight / 28);
                  },
                ),
                Builder(
                  builder: (context) {
                    final screenHeight = MediaQuery.of(context).size.height;
                    return SizedBox(
                      height: screenHeight * 0.42,
                      child: loginCard,
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    final screenHeight = MediaQuery.of(context).size.height;
                    return SizedBox(height: screenHeight * 0.02);
                  },
                ),
                Builder(
                  builder: (context) {
                    final screenHeight = MediaQuery.of(context).size.height;
                    return _wxForgot(context, screenHeight);
                  },
                ),
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
