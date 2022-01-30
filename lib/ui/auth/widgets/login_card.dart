import 'package:flutter/material.dart';

import '../../../foundation/constants.dart';
import '../../../foundation/utils/my_dialog.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../generated/l10n.dart';
import '../signup_screen.dart';
import 'auth_text_field.dart';

class LoginCard extends StatefulWidget {
  const LoginCard(this.parent, {Key? key}) : super(key: key);

  final BuildContext parent;

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  bool saveLogin = true;
  late Stream<AuthState> _authState;

  final borderRadius = 16.0;

  void _login(TextEditingController emailController,
      TextEditingController passwordController) {
    authBloc.add(LoggedIn({
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    }));
  }

  @override
  void initState() {
    _authState = authBloc.stream;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<AuthState>(
        stream: _authState
            .where((state) => state is AuthFailure || state is AuthLoading),
        builder: (context, snapshot) {
          print('<<_LoginCardState>>: StreamBuilder rebuild');
          bool isLoading = false;

          if (snapshot.hasData) {
            if (snapshot.data is AuthFailure) {
              final authFailure = snapshot.data as AuthFailure;
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                MyDialog.show(
                    widget.parent, S.current.error, authFailure.message);
              });
            } else if (snapshot.data is AuthLoading) {
              isLoading = true;
            }
          }

          return Container(
            width: screenWidth > 400 ? 400 : null,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 3,
                  child: _wxEmailField(context, emailController,
                      passwordFocusNode, borderRadius),
                ),
                const SizedBox(height: 4),
                Flexible(
                  flex: 3,
                  child: _wxPasswordField(emailController, passwordController,
                      passwordFocusNode, borderRadius),
                ),
                Flexible(
                  flex: 3,
                  child: _wxSaveLogin(saveLogin),
                ),
                Flexible(
                    flex: 3,
                    child: _wxLoginButton(
                        emailController, passwordController, borderRadius,
                        loading: isLoading)),
                const Spacer(flex: 1),
                Flexible(
                  flex: 3,
                  child: _wxNewAccount(context, emailController,
                      passwordController, borderRadius),
                ),
              ],
            ),
          );
        });
  }

  Widget _wxNewAccount(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController,
      double borderRadius) {
    return SizedBox(
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
                'email': emailController.text.trim(),
                'password': passwordController.text.trim(),
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
              borderRadius: BorderRadius.circular(borderRadius)),
        ),
      ),
    );
  }

  Widget _wxLoginButton(TextEditingController emailController,
      TextEditingController passwordController, double borderRadius,
      {bool loading = false}) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: ElevatedButton(
        child: loading
            ? const CircularProgressIndicator()
            : FractionallySizedBox(
                heightFactor: 0.35,
                child: FittedBox(child: Text(S.current.login)),
              ),
        onPressed: (loading)
            ? null
            : () {
                _login(emailController, passwordController);
              },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          primary: primaryColor,
          onPrimary: Colors.white,
          shadowColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
        ),
      ),
    );
  }

  Widget _wxSaveLogin(bool saveLogin) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Checkbox(
            value: saveLogin,
            onChanged: (value) {
              // TODO:

              // setState(() {
              saveLogin = value!;
              // });
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
    );
  }

  Widget _wxPasswordField(
      TextEditingController _emailController,
      TextEditingController _passwordController,
      FocusNode _passwordFocusNode,
      double _borderRadius) {
    return AuthTextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      labelText: S.current.password,
      onSubmitted: (_) {
        _login(_emailController, _passwordController);
      },
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(_borderRadius),
        bottomRight: Radius.circular(_borderRadius),
      ),
      obscureText: true,
    );
  }

  Widget _wxEmailField(
      BuildContext context,
      TextEditingController _emailController,
      FocusNode passwordFocusNode,
      double borderRadius) {
    return AuthTextField(
      controller: _emailController,
      labelText: S.current.email_address,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(passwordFocusNode);
      },
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
      ),
    );
  }
}
