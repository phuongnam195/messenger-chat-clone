import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_state.dart';
import 'foundation/constants.dart';
import 'generated/l10n.dart';
import 'ui/auth/login_screen.dart';
import 'ui/chat/chat_screen.dart';
import 'ui/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    authBloc.add(AppLaunched());

    return MaterialApp(
      title: 'Messenger',
      debugShowCheckedModeBanner: false,
      theme: appThemeData,
      home: StreamBuilder<AuthState>(
          stream: authBloc.stream.where(
              (state) => state is Authenticated || state is Unauthenticated),
          // initialData: Unauthenticated(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data! is Authenticated) {
                return const HomeScreen();
              } else if (snapshot.data! is Unauthenticated) {
                return const LoginScreen();
              }
            }
            return Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
            );
          }),
      routes: {
        ChatScreen.routeName: (ctx) => const ChatScreen(),
      },
      localizationsDelegates: const [
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
