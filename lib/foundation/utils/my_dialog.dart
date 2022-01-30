import 'package:flutter/material.dart';

class MyDialog {
  static void show(BuildContext parent, String title, String message) {
    showDialog(
        context: parent,
        builder: (ctx) => AlertDialog(
              title: Text(
                title,
                style: const TextStyle(fontSize: 22),
              ),
              content: Text(
                message,
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(fontSize: 18),
                    ))
              ],
            ));
  }
}
