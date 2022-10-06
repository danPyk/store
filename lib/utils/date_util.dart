import 'package:intl/intl.dart';
String getFormattedDate(String timestmapWithMillis) {
  final dateTime = DateTime.parse(timestmapWithMillis);

  print(dateTime.second);

  return "${dateTime.day}-${dateTime.month}-${dateTime.year}  ${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
}
class DateUtils {

}
