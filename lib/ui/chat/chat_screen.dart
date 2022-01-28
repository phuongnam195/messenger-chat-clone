import 'package:flutter/material.dart';

import 'appbar.dart';
import 'body.dart';
import 'bottombar.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final myId = args['myId'];
    final friendId = args['friendId'];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: ChatAppBar(myId: myId, friendId: friendId),
      body: Stack(alignment: AlignmentDirectional.bottomEnd, children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: ChatBody(myId: myId, friendId: friendId),
        ),
        ChatBottomBar(
          myId: myId,
          friendId: friendId,
        ),
      ]),
    );
  }
}
