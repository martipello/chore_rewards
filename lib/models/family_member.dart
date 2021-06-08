import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers/serializers.dart';
import 'chore.dart';
import 'family_member_type.dart';
import 'piggy_bank.dart';

part 'family_member.g.dart';

abstract class FamilyMember implements Built<FamilyMember, FamilyMemberBuilder> {
  factory FamilyMember([void Function(FamilyMemberBuilder) updates]) = _$FamilyMember;

  FamilyMember._();

  String? get id;

  String? get name;

  String? get lastName;

  DateTime? get dateOfBirth;

  PiggyBank? get piggyBank;

  String? get image;

  FamilyMemberType? get familyMemberType;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(FamilyMember.serializer, this) as Map<String, dynamic>;
  }

  static FamilyMember? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(FamilyMember.serializer, json);
  }

  static Serializer<FamilyMember> get serializer => _$familyMemberSerializer;
}
