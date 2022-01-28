import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../signup_screen.dart';
import 'auth_text_field.dart';

class LoginCard extends StatefulWidget {
  const LoginCard(this._onSubmit, {Key? key}) : super(key: key);

  final Future<bool> Function(String email, String password) _onSubmit;

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _canLogin = false;
  bool _saveLogin = true;

  final _borderRadius = 16.0;

  Future<void> _login() async {
    setState(() {
      _canLogin = false;
    });
    final successed = await widget._onSubmit(
        _emailController.text.trim(), _passwordController.text.trim());
    if (!successed) {
      setState(() {
        _canLogin = true;
      });
    }
  }

  @override
  void initState() {
    _emailController.addListener(() {
      if (!_canLogin) {
        if (_emailController.text.trim().trim().isNotEmpty &&
            _passwordController.text.trim().isNotEmpty) {
          setState(() {
            _canLogin = true;
          });
        }
      } else {
        if (_emailController.text.trim().isEmpty) {
          setState(() {
            _canLogin = false;
          });
        }
      }
    });
    _passwordController.addListener(() {
      if (!_canLogin) {
        if (_emailController.text.trim().isNotEmpty &&
            _passwordController.text.trim().isNotEmpty) {
          setState(() {
            _canLogin = true;
          });
        }
      } else {
        if (_passwordController.text.trim().isEmpty) {
          setState(() {
            _canLogin = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth > 400 ? 400 : null,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 3,
            child: AuthTextField(
              controller: _emailController,
              labelText: S.current.auth_field_email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_borderRadius),
                topRight: Radius.circular(_borderRadius),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            flex: 3,
            child: AuthTextField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              labelText: S.current.auth_field_password,
              onSubmitted: (_) async {
                if (_canLogin) {
                  await _login();
                }
              },
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(_borderRadius),
                bottomRight: Radius.circular(_borderRadius),
              ),
              obscureText: true,
            ),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Checkbox(
                    value: _saveLogin,
                    onChanged: (value) {
                      setState(() {
                        _saveLogin = value!;
                      });
                    },
                    shape: const CircleBorder(),
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                  ),
                  Text(
                    S.current.save_login,
                    style: TextStyle(
                        color: Colors.grey[500],
                        // fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ElevatedButton(
                child: FractionallySizedBox(
                    heightFactor: 0.35,
                    child: FittedBox(child: Text(S.current.login))),
                onPressed: (!_canLogin)
                    ? null
                    : () async {
                        await _login();
                      },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  textStyle: TextStyle(
                    fontWeight: _canLogin ? FontWeight.w500 : FontWeight.w400,
                  ),
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                  shadowColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_borderRadius)),
                ),
              ),
            ),
          ),
          const Spacer(flex: 1),
          Flexible(
            flex: 3,
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ElevatedButton(
                child: FractionallySizedBox(
                    heightFactor: 0.35,
                    child: FittedBox(child: Text(S.current.new_account))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignUpScreen(),
                      settings: RouteSettings(arguments: {
                        'email': _emailController.text.trim(),
                        'password': _passwordController.text.trim(),
                      }),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  textStyle: const TextStyle(
                    // fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shadowColor: Colors.transparent,
                  primary: Colors.black.withOpacity(0.03),
                  onPrimary: Colors.black87,
                  splashFactory: NoSplash.splashFactory,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_borderRadius)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
