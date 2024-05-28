import 'package:intl/intl.dart';
dateAndtime() {
  DateTime dateTime = DateTime.now();
  String formattedTime = DateFormat('h:mm a').format(dateTime);
  String formattedDate = DateFormat('d/MM/yyyy').format(dateTime);
 return   "$formattedTime $formattedDate";
 
}
DateTime parseDateTime(String dateTimeString) {
  final DateFormat formatter = DateFormat('h:mm a d/MM/yyyy');
  return formatter.parse(dateTimeString);
}

String formatDateTime(String dateTimeString) {
  DateTime now = DateTime.now();
  DateTime dateTime = parseDateTime(dateTimeString);
  String formattedTime = DateFormat('h:mm a').format(dateTime);
  String formattedDate = DateFormat('d/MM/yyyy').format(dateTime);

  if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
    return formattedTime; 
  } else if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day - 1) {
    return 'Yesterday'; 
  } else {
    return formattedDate; 
  }
}