// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FamilyMemberType _$parent = const FamilyMemberType._('parent');
const FamilyMemberType _$child = const FamilyMemberType._('child');

FamilyMemberType _$familyMemberTypeValueOf(String name) {
  switch (name) {
    case 'parent':
      return _$parent;
    case 'child':
      return _$child;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<FamilyMemberType> _$familyMemberTypeValues =
    new BuiltSet<FamilyMemberType>(const <FamilyMemberType>[
  _$parent,
  _$child,
]);

Serializer<FamilyMemberType> _$familyMemberTypeSerializer =
    new _$FamilyMemberTypeSerializer();

class _$FamilyMemberTypeSerializer
    implements PrimitiveSerializer<FamilyMemberType> {
  @override
  final Iterable<Type> types = const <Type>[FamilyMemberType];
  @override
  final String wireName = 'FamilyMemberType';

  @override
  Object serialize(Serializers serializers, FamilyMemberType object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  FamilyMemberType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FamilyMemberType.valueOf(serialized as String);
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
