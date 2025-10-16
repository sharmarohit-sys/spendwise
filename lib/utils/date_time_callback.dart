import 'package:intl/intl.dart';

class DateTimeCallback {
  static String getTimeInString(DateTime dateTime) {
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }
}
