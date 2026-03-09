import 'package:intl/intl.dart';

String formatDate(DateTime time) {
  return DateFormat('MMMM d, yyyy').format(time);
}
