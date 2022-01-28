import 'package:cloud_firestore/cloud_firestore.dart';

import '../generated/l10n.dart';

class Message {
  final String id;
  final String sender;
  final Timestamp time;
  final String content;
  final String type;

  Message(
      {required this.id,
      required this.sender,
      required this.time,
      required this.content,
      required this.type});

  bool get isText => type == 'text';
  bool get isImage => type == 'image';
  bool get isLike => type == 'like';
  bool get isUrl => type == 'url';
  bool get isGif => type == 'gif';

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
        id: id,
        sender: map['sender'],
        time: map['time'],
        content: map['content'],
        type: map['type']);
  }

  Map<String, dynamic> toMap() => {
        'sender': sender,
        'time': time,
        'content': content,
        'type': type,
      };

  String get brief {
    switch (type) {
      case 'text':
        return content;
      case 'image':
        return S.current.brief_image;
      case 'like':
        return S.current.brief_like;
      case 'url':
        return S.current.brief_url;
      case 'gif':
        return S.current.brief_gif;
      default:
        return '';
    }
  }
}
