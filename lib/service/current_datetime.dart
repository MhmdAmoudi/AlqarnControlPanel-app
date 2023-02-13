import 'package:date_format/date_format.dart';

String? getZoneDatetime(String? utcDatetime, {bool withTime = false}) {
  if (utcDatetime != null) {
    DateTime deviceDatetime =
        DateTime.parse(utcDatetime).add(DateTime.now().timeZoneOffset);
    if (withTime) {
      String period = deviceDatetime.hour > 11 ? 'م' : 'ص';
      return formatDate(
        deviceDatetime,
        [hh, ':', nn, '$period - ', yyyy, '/', mm, '/', dd],
      );
    } else {
      return formatDate(
        deviceDatetime,
        [yyyy, '/', mm, '/', dd],
      );
    }
  }
  return null;
}
