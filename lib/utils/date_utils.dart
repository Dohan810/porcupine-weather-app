import 'package:intl/intl.dart';

class CustomDateUtils {
  /// Formats a [DateTime] object into a string in the format 'EEEE, d MMMM'.
  ///
  /// Example:
  /// ```
  /// DateTime date = DateTime(2023, 6, 13);
  /// String formattedDate = DateUtils.formatDate(date);
  /// // formattedDate will be 'TUESDAY, 13 JUNE'
  /// ```
  static String formatDate(DateTime date) {
    return DateFormat('EEEE, d MMMM').format(date).toUpperCase();
  }
}
