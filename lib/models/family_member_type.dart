import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers/serializers.dart';

part 'family_member_type.g.dart';

class FamilyMemberType extends EnumClass {
  const FamilyMemberType._(String name) : super(name);

  static const FamilyMemberType parent = _$parent;
  static const FamilyMemberType child = _$child;

  static BuiltSet<FamilyMemberType> get values => _$familyMemberTypeValues;
  static FamilyMemberType valueOf(String name) => _$familyMemberTypeValueOf(name);

  String serialize() {
    return serializers.serializeWith(FamilyMemberType.serializer, this) as String;
  }

  static FamilyMemberType? deserialize(String string) {
    return serializers.deserializeWith(FamilyMemberType.serializer, string);
  }

  static Serializer<FamilyMemberType> get serializer => _$familyMemberTypeSerializer;
}
