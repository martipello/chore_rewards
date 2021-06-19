import '../models/family.dart';

extension FamilyExtension on Family {
  String heroTag(){
    return '$name$image$id';
  }
}