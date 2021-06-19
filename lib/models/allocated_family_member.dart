import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers/serializers.dart';

part 'allocated_family_member.g.dart';

abstract class AllocatedFamilyMember implements Built<AllocatedFamilyMember, AllocatedFamilyMemberBuilder> {
  factory AllocatedFamilyMember([void Function(AllocatedFamilyMemberBuilder) updates]) = _$AllocatedFamilyMember;

  AllocatedFamilyMember._();

  String? get id;

  String? get name;

  String? get lastName;

  String? get image;

  double? get balance;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(AllocatedFamilyMember.serializer, this) as Map<String, dynamic>;
  }

  static AllocatedFamilyMember? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(AllocatedFamilyMember.serializer, json);
  }

  static Serializer<AllocatedFamilyMember> get serializer => _$allocatedFamilyMemberSerializer;
}
