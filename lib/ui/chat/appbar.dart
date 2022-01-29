import 'dart:ui';

import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../../foundation/extensions/meta_icons_icons.dart';
import '../../../blocs/friend_bloc.dart';
import '../../../models/profile.dart';
import '../common/avatar.dart';
import '../common/online_dot.dart';
import '../../../foundation/utils/my_dialog.dart';
import 'button.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({Key? key, required this.myId, required this.friendId})
      : super(key: key);

  final String myId;
  final String friendId;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(width: 10);
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var titlePadding = EdgeInsets.only(top: statusBarHeight + 8, bottom: 8);

    final friendBloc = FriendBlocsCache.instance.get(myId, friendId);

    return PreferredSize(
      preferredSize: preferredSize,
      child: Stack(children: [
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 15),
            child: Container(
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ),
        StreamBuilder<Profile>(
            stream: friendBloc.profile,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.hasError) {
                return Container();
              }
              final friendProfile = snapshot.data!;
              return Row(
                children: [
                  spacing,
                  _buttomBack(context),
                  spacing,
                  _title(titlePadding, friendProfile, context, friendBloc),
                  const Spacer(),
                  _buttonAudioCall(context),
                  _buttonVideoCall(context),
                  const SizedBox(width: 2),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 10,
                        bottom: 10),
                    child: const OnlineDot(radius: 5),
                  ),
                  const SizedBox(width: 5),
                ],
              );
            })
      ]),
    );
  }

  Padding _title(EdgeInsets titlePadding, Profile friendProfile,
      BuildContext context, FriendBloc friendBloc) {
    return Padding(
      padding: titlePadding,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: FittedBox(child: Avatar(friendProfile.avatarUrl)),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              friendProfile.fullname,
              style: Theme.of(context).textTheme.headline3,
            ),
            StreamBuilder<bool>(
                stream: friendBloc.online,
                builder: (ctx, snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return Text(
                      S.current.is_online,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontSize: 13),
                    );
                  } else {
                    return Container();
                  }
                })
          ],
        ),
      ]),
    );
  }

  Widget _buttomBack(BuildContext context) {
    return ChatButton(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10, bottom: 10),
      icon: MetaIcons.arrow_back,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buttonVideoCall(BuildContext context) {
    return ChatButton(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10, bottom: 10),
      icon: MetaIcons.call_video,
      onPressed: () {
        MyDialog.show(
            context, 'Gọi video', 'Tính năng này sẽ có trong tương lai.');
      },
    );
  }

  Widget _buttonAudioCall(BuildContext context) {
    return ChatButton(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 4, bottom: 4),
      icon: MetaIcons.phone,
      onPressed: () {
        MyDialog.show(
            context, 'Gọi thoại', 'Tính năng này sẽ có trong tương lai.');
      },
    );
  }
}
