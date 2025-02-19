import 'package:intl/intl.dart';

String baseUrl = "https://newsapi.org/";

///date formate
String formatDate(DateTime? date) {
  if (date == null) return "Unknown Date";
  return DateFormat('yyyy-MM-dd').format(date);
}
