import 'package:intl/intl.dart';

class UtilsDate {
  static final dateFormat = DateFormat('EEE, MMM d, ' 'yy');
  static final timeFormat = DateFormat('hh:mm');

  static final earliestDate = DateTime(2022, 6, 0);
  static final latestDate = DateTime(2025);
}
