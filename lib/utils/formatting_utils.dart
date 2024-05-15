import 'package:flutter/cupertino.dart';

SizedBox addSpace(double multiplier) {
  const baseIncrement = 4.0;
  return SizedBox(
    height: baseIncrement * multiplier,
    width: baseIncrement * multiplier,
  );
}

String capitalize(String input) {
  return input.split(' ').map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
    return word;
  }).join(' ');
}
