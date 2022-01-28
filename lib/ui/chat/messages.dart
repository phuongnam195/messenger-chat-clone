import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../foundation/utils/validator.dart';
import '../../foundation/constants.dart';

const _padding = EdgeInsets.symmetric(horizontal: 15, vertical: 5);

enum BubbleType { top, middle, bottom, single }

class TextMessage extends StatelessWidget {
  final String content;
  final bool isMine;
  final BubbleType bubbleType;
  final String theme;

  const TextMessage({
    Key? key,
    required this.content,
    required this.isMine,
    this.bubbleType = BubbleType.single,
    this.theme = 'default',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: _margin(),
        padding: const EdgeInsets.all(8),
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMine ? chatTheme[theme] : friendMessageColor,
          borderRadius: _borderRadius(),
        ),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Validator.url(content)
                ? GestureDetector(
                    onTap: () async {
                      if (await canLaunch(content)) {
                        await launch(content);
                      }
                    },
                    child: Text(
                      content,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: isMine ? Colors.white : Colors.black,
                          decoration: TextDecoration.underline),
                      textAlign: TextAlign.start,
                    ),
                  )
                : Text(
                    content,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontFamily: 'Segoe UI Emojis',
                        color: isMine ? Colors.white : Colors.black),
                    textAlign: TextAlign.start,
                  ),
          ],
        ),
      ),
    );
  }

  BorderRadius _borderRadius() {
    const rounded = Radius.circular(12);
    const unround = Radius.circular(2);

    if (bubbleType == BubbleType.single) {
      return const BorderRadius.all(rounded);
    }

    Radius topLeft = rounded;
    Radius topRight = rounded;
    Radius bottomLeft = rounded;
    Radius bottomRight = rounded;

    // Giả sử tin nhắn của mình
    if (bubbleType == BubbleType.top) {
      bottomRight = unround;
    } else if (bubbleType == BubbleType.middle) {
      topRight = unround;
      bottomRight = unround;
    } else {
      topRight = unround;
    }

    // Nếu của đối phương thì flip horizontal
    if (!isMine) {
      return BorderRadius.only(
        topLeft: topRight,
        bottomLeft: bottomRight,
        topRight: topLeft,
        bottomRight: bottomLeft,
      );
    }

    return BorderRadius.only(
      topLeft: topLeft,
      bottomLeft: bottomLeft,
      topRight: topRight,
      bottomRight: bottomRight,
    );
  }

  EdgeInsets _margin() {
    const horizontal = 15.0;
    const big = 5.0;
    const small = 1.0;

    if (bubbleType == BubbleType.single) {
      return const EdgeInsets.symmetric(
        vertical: big,
        horizontal: horizontal,
      );
    }

    if (bubbleType == BubbleType.top) {
      return const EdgeInsets.only(
        top: big,
        bottom: small,
        left: horizontal,
        right: horizontal,
      );
    }

    if (bubbleType == BubbleType.bottom) {
      return const EdgeInsets.only(
        top: small,
        bottom: big,
        left: horizontal,
        right: horizontal,
      );
    }

    return const EdgeInsets.symmetric(
      vertical: small,
      horizontal: horizontal,
    );
  }
}

class ImageMessage extends StatelessWidget {
  const ImageMessage({Key? key, required this.url, required this.isMine})
      : super(key: key);

  final String url;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    var alignment = isMine ? Alignment.centerRight : Alignment.centerLeft;
    var borderRadius = BorderRadius.circular(12);
    var maxWidth = MediaQuery.of(context).size.width * 0.65;
    var maxHeight = MediaQuery.of(context).size.height * 0.5;

    return Align(
      alignment: alignment,
      child: Container(
        padding: _padding,
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 30,
              color: Colors.grey,
              child: const Icon(Icons.error_outline_rounded),
            ),
          ),
        ),
      ),
    );
  }
}

class LikeMessage extends StatelessWidget {
  const LikeMessage({Key? key, required this.isMine, required this.theme})
      : super(key: key);

  final bool isMine;
  final String theme;

  @override
  Widget build(BuildContext context) {
    const size = 44.0;
    var alignment = isMine ? Alignment.centerRight : Alignment.centerLeft;
    var color = chatTheme[theme];

    return Container(
        alignment: alignment,
        padding: _padding,
        child: Image.asset(
          './assets/images/like-button-64.png',
          color: color,
          width: size,
          fit: BoxFit.fitWidth,
        ));
  }
}
