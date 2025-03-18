import 'package:intl/intl.dart';

String baseUrl = "https://newsapi.org/";

///date formated
String formatDate(DateTime? date) {
  if (date == null) return "Unknown Date";
  return DateFormat('yyyy-MM-dd').format(date);
}

///hottest news api url
String hottestNews =
    "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=feac6772bf7143e1976d85e79fb8633a";

///news for you api url
String newsForYou =
    "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=feac6772bf7143e1976d85e79fb8633a";
