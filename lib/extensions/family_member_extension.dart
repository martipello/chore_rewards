import '../models/family_member.dart';

extension FamilyMemberExtension on FamilyMember {
  String heroTag(){
    return '$name$image$id';
  }
}