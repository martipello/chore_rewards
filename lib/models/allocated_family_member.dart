import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers/serializers.dart';
import 'chore.dart';
import 'family_member_type.dart';
import 'piggy_bank.dart';

part 'allocated_family_member.g.dart';

abstract class AllocatedFamilyMember implements Built<AllocatedFamilyMember, AllocatedFamilyMemberBuilder> {
  factory AllocatedFamilyMember([void Function(AllocatedFamilyMemberBuilder) updates]) = _$AllocatedFamilyMember;

  AllocatedFamilyMember._();

  String? get id;

  String? get name;

  String? get lastName;

  String? get image;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(AllocatedFamilyMember.serializer, this) as Map<String, dynamic>;
  }

  static AllocatedFamilyMember? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(AllocatedFamilyMember.serializer, json);
  }

  static Serializer<AllocatedFamilyMember> get serializer => _$allocatedFamilyMemberSerializer;
}
