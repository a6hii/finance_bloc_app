import 'package:intl/intl.dart';

DateTime getDateTime(String date) {
  // Assuming _dateController.text contains 'dd/MM/yyyy'
  final inputDate = DateFormat('dd/MM/yyyy').parse(date);
  final currentDate = DateTime.now();

  return DateTime(
    inputDate.year,
    inputDate.month,
    inputDate.day,
    currentDate.hour,
    currentDate.minute,
    currentDate.second,
  );
}
