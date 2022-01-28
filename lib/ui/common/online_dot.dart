import 'package:flutter/material.dart';

import '../../foundation/constants.dart';

class OnlineDot extends StatelessWidget {
  final double radius;
  final double? borderWidth;
  final Color? borderColor;

  const OnlineDot({
    required this.radius,
    this.borderWidth,
    this.borderColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = borderWidth != null ? (radius + borderWidth!) * 2 : radius * 2;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: borderColor ?? onlineColor,
        shape: BoxShape.circle,
      ),
      child: borderWidth == null
          ? null
          : Center(
              child: Container(
                width: radius * 2,
                height: radius * 2,
                decoration: const BoxDecoration(
                  color: onlineColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
    );
  }
}
