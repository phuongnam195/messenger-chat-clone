import 'package:flutter/material.dart';

import '../../../blocs/chat_bloc.dart';
import '../../../models/message.dart';
import 'messages.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({Key? key, required this.myId, required this.friendId})
      : super(key: key);

  final String myId;
  final String friendId;

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  late final ChatBloc chatBloc;
  final scrollThreshold = 100.0;
  final scrollController = ScrollController();
  final List<Message> messages = [];
  bool isLoadingMore = false;

  // void onScroll() {
  //   // final maxScroll = scrollController.position.maxScrollExtent;
  //   // final currentScroll = scrollController.position.pixels;
  //   print(scrollController.position.extentBefore);
  //   if (scrollController.position.extentBefore > scrollThreshold &&
  //       !isLoadingMore) {
  //     chatBloc.loadMoreMessage(messages.last.time);
  //     isLoadingMore = true;
  //   }
  // }

  // Future<void> loadMore() async {
  //   chatBloc.loadMoreMessage(messages.last.time);
  // }

  @override
  void initState() {
    chatBloc = ChatBlocsCache.instance.get(widget.myId, widget.friendId);
    // scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Messages>(
        stream: chatBloc.messages,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isOld) {
              messages.addAll(snapshot.data!.list);
              isLoadingMore = false;
            } else {
              messages.insertAll(0, snapshot.data!.list);
            }
          }
          return ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              reverse: true,
              controller: scrollController,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top, bottom: 50),
              itemCount: messages.length,
              itemBuilder: (ctx, index) {
                final message = messages[index];
                final isMine = message.sender == widget.myId;
                switch (message.type) {
                  case 'text':
                  case 'url':
                    return TextMessage(
                      content: message.content,
                      isMine: isMine,
                      key: ValueKey(message.id),
                      bubbleType: _getBubbleType(index, messages),
                    );
                  case 'image':
                  case 'gif':
                    return ImageMessage(
                      url: message.content,
                      isMine: isMine,
                      key: ValueKey(message.id),
                    );
                  case 'like':
                    return LikeMessage(
                      isMine: isMine,
                      theme: 'default', // TODO:
                      key: ValueKey(message.id),
                    );
                }
                return Container();
              });
        });
  }

  bool _isMine(Message message) {
    return message.sender == widget.myId;
  }

  BubbleType _getBubbleType(int index, List<Message> messages) {
    // Chỉ có duy nhất 1 tin nhắn
    if (messages.length == 1) {
      return BubbleType.single;
    }

    // Là tin nhắn mới nhất (dưới cùng),
    if (index == 0) {
      // và tin nhắn kế trên là của đối phương
      if (_isMine(messages[index]) != _isMine(messages[index + 1])) {
        return BubbleType.single;
      }
      // ngược lại, là của mình
      else {
        return BubbleType.bottom;
      }
    }

    // Là tin nhắn cũ nhất (trên cùng),
    if (index == messages.length - 1) {
      // và tin nhắn kế dưới là của đối phương
      if (_isMine(messages[index]) != _isMine(messages[index - 1])) {
        return BubbleType.single;
      }
      // ngược lại, là của mình
      else {
        return BubbleType.top;
      }
    }

    // Tin nhắn kế trên là của đối phương
    if (_isMine(messages[index]) != _isMine(messages[index + 1])) {
      // Tin nhắn kế dưới cũng là của đối phương
      if (_isMine(messages[index]) != _isMine(messages[index - 1])) {
        return BubbleType.single;
      }
      // Tin nhắn kế dưới là của mình
      else {
        return BubbleType.top;
      }
    }

    // Tin nhắn kế dưới là của đối phương
    if (_isMine(messages[index]) != _isMine(messages[index - 1])) {
      return BubbleType.bottom;
    }

    return BubbleType.middle;
  }
}
