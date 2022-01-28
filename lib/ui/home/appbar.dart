import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../common/avatar.dart';
import '../../models/profile.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key, required this.profile}) : super(key: key);

  final Profile profile;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      leading: Container(
        padding: const EdgeInsets.all(12),
        child: Avatar(profile.avatarUrl),
      ),
      backgroundColor: Colors.white.withOpacity(0.9),
      title: Text(
        'Chat',
        style: Theme.of(context).textTheme.headline1,
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.black,
          ),
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ],
    );
  }
}
