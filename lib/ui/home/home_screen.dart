import 'package:flutter/material.dart';

import '../../blocs/home_bloc.dart';
import '../../blocs/account_bloc.dart';
import '../../generated/l10n.dart';
import '../../models/account.dart';
import 'appbar.dart';
import 'bottombar.dart';
import 'pages/chat_page.dart';
import 'pages/people_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    accountBloc.fetchAccount();

    return StreamBuilder<Account>(
      stream: accountBloc.currentAccount,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline),
              Text(S.current.unknown_error),
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(),
          );
        }

        final currentAccount = snapshot.data!;
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: HomeAppBar(profile: currentAccount.profile),
          body: StreamBuilder<int>(
              stream: homeBloc.page,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == 1) {
                    return const PeoplePage();
                  }
                }
                return ChatPage(
                  myId: currentAccount.profile.id,
                  friendIDs: currentAccount.friendIDs,
                );
              }),
          extendBody: true,
          bottomNavigationBar: const HomeBottomBar(),
        );
      },
    );
  }
}
