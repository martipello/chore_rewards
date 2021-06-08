import '../models/chore.dart';

extension ChoreExtension on Chore {
  bool isExpired() {
    if (expiryDate != null) {
      return date(DateTime.now()).difference(date(expiryDate!)).inHours > 0;
    }
    return false;
  }

  bool isChoreAvailableToFamilyMember(String userId){
    return allocatedToFamilyMember == null ||
        allocatedToFamilyMember?.id?.isEmpty == true ||
        allocatedToFamilyMember?.id == userId;
  }

  DateTime date(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);
}