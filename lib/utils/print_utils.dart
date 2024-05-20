import 'package:flutter/foundation.dart';

class PrintUtils {
  /// Prints a [String] in red color in the console.
  ///
  /// Example:
  /// ```
  /// PrintUtils.printRed("This is a red message.");
  /// ```
  static void printRed(String text) {
    if (kDebugMode) {
      print('\x1B[31m$text\x1B[0m');
    }
  }

  /// Prints a [String] in green color in the console.
  ///
  /// Example:
  /// ```
  /// PrintUtils.printGreen("This is a green message.");
  /// ```
  static void printGreen(String text) {
    if (kDebugMode) {
      print('\x1B[32m$text\x1B[0m');
    }
  }

  /// Prints a [String] in yellow color in the console.
  ///
  /// Example:
  /// ```
  /// PrintUtils.printYellow("This is a yellow message.");
  /// ```
  static void printYellow(String text) {
    if (kDebugMode) {
      print('\x1B[33m$text\x1B[0m');
    }
  }

  /// Prints a [String] in blue color in the console.
  ///
  /// Example:
  /// ```
  /// PrintUtils.printBlue("This is a blue message.");
  /// ```
  static void printBlue(String text) {
    if (kDebugMode) {
      print('\x1B[34m$text\x1B[0m');
    }
  }

  /// Prints a [String] in magenta color in the console.
  ///
  /// Example:
  /// ```
  /// PrintUtils.printMagenta("This is a magenta message.");
  /// ```
  static void printMagenta(String text) {
    if (kDebugMode) {
      print('\x1B[35m$text\x1B[0m');
    }
  }

  /// Prints a [String] in cyan color in the console.
  ///
  /// Example:
  /// ```
  /// PrintUtils.printCyan("This is a cyan message.");
  /// ```
  static void printCyan(String text) {
    if (kDebugMode) {
      print('\x1B[36m$text\x1B[0m');
    }
  }

  /// Prints a [String] in white color in the console.
  ///
  /// Example:
  /// ```
  /// PrintUtils.printWhite("This is a white message.");
  /// ```
  static void printWhite(String text) {
    if (kDebugMode) {
      print('\x1B[37m$text\x1B[0m');
    }
  }
}
