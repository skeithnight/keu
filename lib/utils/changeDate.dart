import 'package:intl/intl.dart';

String changeDate(DateTime date){
  var formatter = new DateFormat('dd-MM-yyyy');
  String formatted = formatter.format(date);
  return formatted;
}