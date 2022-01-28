import 'package:flutter/material.dart';

import '../../../foundation/constants.dart';

class ChatButton extends StatefulWidget {
  final IconData icon;
  final void Function() onPressed;
  final EdgeInsets? margin;
  final Color? color;

  const ChatButton(
      {required this.icon,
      required this.onPressed,
      this.margin,
      this.color,
      Key? key})
      : super(key: key);

  @override
  _ChatButtonState createState() => _ChatButtonState();
}

class _ChatButtonState extends State<ChatButton> {
  late Color _color;
  late Color _originalColor;
  late Color _hoverColor;

  @override
  void initState() {
    _color = widget.color ?? chatTheme['default']!;
    _originalColor = _color;
    _hoverColor = _color.withOpacity(0.7);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: widget.margin ?? const EdgeInsets.symmetric(vertical: 10),
        child: FittedBox(
          child: Icon(
            widget.icon,
            color: _color,
            size: 50,
          ),
        ),
      ),
      onTap: widget.onPressed,
      onTapDown: (_) {
        setState(() {
          _color = _hoverColor;
        });
      },
      onTapUp: (_) {
        setState(() {
          _color = _originalColor;
        });
      },
      onPanEnd: (_) {
        setState(() {
          _color = _originalColor;
        });
      },
    );
  }
}
