import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_chat_clone/generated/l10n.dart';

import '../../../foundation/extensions/meta_icons_icons.dart';
import '../../../blocs/chat_bloc.dart';
import '../../../models/message.dart';
import '../../../foundation/utils/firebase_helper.dart';
import '../../../foundation/utils/misc.dart';
import '../../../foundation/constants.dart';
import 'button.dart';

class ChatBottomBar extends StatelessWidget {
  ChatBottomBar({Key? key, required this.myId, required this.friendId})
      : chatBloc = ChatBlocsCache.instance.get(myId, friendId),
        super(key: key);

  final String myId;
  final String friendId;
  final ChatBloc chatBloc;

  @override
  Widget build(BuildContext context) {
    const SPACING = SizedBox(width: 15);
    const HORIZONTAL = SizedBox(width: 12);

    final textController = TextEditingController();
    final textFieldFocusNode = FocusNode();
    chatBloc.setTypingListener(textController);

    return Stack(children: [
      SizedBox(
        height: kToolbarHeight,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 15),
            child: Container(
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ),
      ),
      SizedBox(
        height: kToolbarHeight,
        child: Row(
          children: [
            HORIZONTAL,
            _buttonCamera(context),
            SPACING,
            _buttonGallery(context),
            SPACING,
            _buttonGIF(context),
            SPACING,
            _textField(
              controller: textController,
              focusNode: textFieldFocusNode,
              onEditingComplete: () {
                _sendMessage('text', text: textController.text.trim());
                textController.clear();
              },
              context: context,
            ),
            SPACING,
            _buttonSend(textController),
            HORIZONTAL,
          ],
        ),
      ),
    ]);
  }

  Widget _buttonSend(TextEditingController textController) {
    return StreamBuilder(
      stream: chatBloc.typing,
      builder: (ctx, snapshot) {
        if (snapshot.hasData && snapshot.data! == true) {
          return ChatButton(
              icon: MetaIcons.send,
              onPressed: () {
                _sendMessage('text', text: textController.text.trim());
                textController.clear();
              });
        }
        return ChatButton(
          icon: MetaIcons.thumb_up,
          onPressed: () => _sendMessage('like'),
        );
      },
    );
  }

  Widget _buttonGIF(BuildContext context) {
    return ChatButton(
        icon: MetaIcons.gif,
        onPressed: () async {
          final gif = await GiphyPicker.pickGif(
            context: context,
            apiKey: 'Ji3biJDZ1TMu7PFJGbnG4cHDb793R956',
            lang: S.current.language == "Tiếng Việt"
                ? GiphyLanguage.vietnamese
                : GiphyLanguage.english,
          );
          if (gif != null &&
              gif.images.original != null &&
              gif.images.original!.url != null) {
            _sendMessage('gif', text: gif.images.original!.url);
          }
        });
  }

  Widget _buttonGallery(BuildContext context) {
    return ChatButton(
        icon: MetaIcons.gallery,
        onPressed: () async {
          await _pickImage(context, ImageSource.gallery);
        });
  }

  Widget _buttonCamera(BuildContext context) {
    return ChatButton(
        icon: MetaIcons.camera,
        onPressed: () async {
          await _pickImage(context, ImageSource.camera);
        });
  }

  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required Function onEditingComplete,
    required BuildContext context,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          style: Theme.of(context).textTheme.bodyText1,
          cursorHeight: 24,
          cursorWidth: 1.8,
          cursorRadius: const Radius.circular(3),
          cursorColor: chatTheme['default'],
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black.withAlpha(6),
            hintText: ' Aa',
            hintStyle: Theme.of(context).textTheme.subtitle2,
            hoverColor: Colors.transparent,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendMessage(String type, {String? text, File? file}) async {
    final now = Timestamp.now();
    final id = now.toDate().toIso8601String();
    String? content;
    switch (type) {
      case 'text':
      case 'gif':
        content = text;
        break;
      case 'image':
        content = await FirebaseHelper.uploadFile(
            'chat_images/${combineID(myId, friendId)}/$id', file!);
        break;
      case 'like':
        // TODO:
        content = 'big';
    }

    final message = Message(
        id: now.toDate().toIso8601String(),
        content: content!,
        sender: myId,
        time: now,
        type: type);
    chatBloc.sendMessage(message, friendId);
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage == null) {
      return;
    }
    File imageFile = File(pickedImage.path);
    await _sendMessage('image', file: imageFile);
  }
}
