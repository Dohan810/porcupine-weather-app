import 'package:flutter/cupertino.dart';

/// Returns a [SizedBox] with height and width multiplied by a base increment.
///
/// The base increment is 4.0. The [multiplier] parameter is used to scale
/// the height and width of the [SizedBox].
///
/// Example:
/// ```
/// SizedBox space = addSpace(2);
/// // This creates a SizedBox with height and width of 8.0 (4.0 * 2).
/// ```
///
/// [multiplier] - A double value to scale the base increment.
SizedBox addSpace(double multiplier) {
  const baseIncrement = 4.0;
  return SizedBox(
    height: baseIncrement * multiplier,
    width: baseIncrement * multiplier,
  );
}

/// Capitalizes each word in the given [input] string.
///
/// This method splits the [input] string by spaces, capitalizes the first letter
/// of each word, and joins them back together with spaces.
///
/// Example:
/// ```
/// String text = 'hello world';
/// String capitalizedText = capitalize(text);
/// // capitalizedText will be 'Hello World'
/// ```
///
/// [input] - The string to be capitalized.
/// Returns the capitalized string.
String capitalize(String input) {
  return input.split(' ').map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
    return word;
  }).join(' ');
}
