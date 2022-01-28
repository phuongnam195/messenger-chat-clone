import 'package:flutter/material.dart';
import 'package:messenger_chat_clone/blocs/people_bloc.dart';

import '../../../blocs/home_bloc.dart';
import '../../../foundation/constants.dart';
import '../../../foundation/extensions/meta_icons_icons.dart';
import '../../../generated/l10n.dart';
import '../../../models/profile.dart';
import '../../common/avatar.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    peopleBloc.fetchPeople();

    return StreamBuilder<List<Profile>>(
      stream: peopleBloc.people,
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
          itemBuilder: (context, index) {
            final profile = users[index];
            return PersonItem(profile: profile);
          },
        );
      },
    );
  }
}

class PersonItem extends StatelessWidget {
  const PersonItem({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.all(5),
        child: Avatar(profile.avatarUrl),
      ),
      title:
          Text(profile.fullname, style: Theme.of(context).textTheme.headline2),
      trailing: IconButton(
        icon: const Icon(MetaIcons.add_friend, size: 34, color: primaryColor),
        onPressed: () {},
        tooltip: S.current.add_friend,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      horizontalTitleGap: 8,
    );
  }
}
