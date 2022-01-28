import 'package:flutter/material.dart';

class Converter {
  static String toConciseTime(DateTime input) {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    if (input.compareTo(today) >= 0) {
      var hour = input.hour;
      var minute = input.minute;
      var output = '';
      if (hour < 10) output += '0';
      output += '$hour:';
      if (minute < 10) output += '0';
      output += '$minute';
      return output;
    }
    var lastWeek =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: 7));
    if (input.compareTo(lastWeek) >= 0) {
      if (input.weekday == 7) {
        return 'CN';
      }
      return 'Th ${input.weekday + 1}';
    }
    if (input.year == now.year) {
      return '${input.day} thg ${input.month}';
    }
    return '${input.day}/${input.month}/${input.year}';
  }

  static String safeTextOverflow(String str) {
    // return str.replaceAll('', '\u200B');
    return Characters(str)
        .replaceAll(Characters(''), Characters('\u{200B}'))
        .toString();
  }
}
