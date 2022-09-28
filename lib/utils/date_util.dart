import 'package:intl/intl.dart';
String getFormattedDate(String timestmapWithMillis) {
  var dateTime =
  DateFormat.EEEE("yyyy-MM-dd HH:mm:ss").parse(timestmapWithMillis);

  return "${dateTime.day}-${dateTime.month}-${dateTime.year}  ${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
}
class DateUtils {

}
