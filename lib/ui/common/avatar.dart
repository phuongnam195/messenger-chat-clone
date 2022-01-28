import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar(this.avatarUrl, {Key? key}) : super(key: key);

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
        child: avatarUrl != null
            ? Image.network(avatarUrl!,
                errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.white,
                    ))
            : Image.asset('assets/images/blank-avatar-60.png'));
  }
}
