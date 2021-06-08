import '../models/chore.dart';

extension ChoreExtension on Chore {
  bool isExpired() {
    if (expiryDate != null) {
      return date(DateTime.now()).difference(date(expiryDate!)).inHours > 0;
    }
    return false;
  }

  DateTime date(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);
}