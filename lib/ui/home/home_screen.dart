import 'package:flutter/material.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/home_bloc.dart';
import '../../generated/l10n.dart';
import 'appbar.dart';
import 'bottombar.dart';
import 'pages/friend_page.dart';
import 'pages/people_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: authBloc.stream.where((state) => state is Authenticated),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(),
            ),
          );
        }

        if (snapshot.data! is Authenticated) {
          final authenticated = snapshot.data as Authenticated;
          final profile = authenticated.profile;
          final friendIDs = authenticated.friendIDs;

          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            appBar: HomeAppBar(profile: profile),
            body: StreamBuilder<int>(
                stream: homeBloc.page,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == 1) {
                      return const PeoplePage();
                    }
                  }
                  return FriendPage(
                    myId: profile.uid,
                    friendIDs: friendIDs,
                  );
                }),
            extendBody: true,
            bottomNavigationBar: const HomeBottomBar(),
          );
        }

        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline),
              Text(S.current.unknown_error),
            ],
          ),
        );
      },
    );
  }
}
