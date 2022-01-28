import 'package:flutter/material.dart';
import 'package:messenger_chat_clone/blocs/home_bloc.dart';
import 'package:messenger_chat_clone/models/profile.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    homeBloc.fetchPeople();

    return StreamBuilder<List<Profile>>(
      stream: homeBloc.people,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('ERROR'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(),
          );
        }

        final users = snapshot.data!;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) => Text(users[index].fullname),
        );
      },
    );
  }
}
