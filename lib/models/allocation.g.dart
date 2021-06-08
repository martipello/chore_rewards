// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const Allocation _$none = const Allocation._('none');
const Allocation _$available = const Allocation._('available');
const Allocation _$allocated = const Allocation._('allocated');
const Allocation _$completed = const Allocation._('completed');

Allocation _$allocationValueOf(String name) {
  switch (name) {
    case 'none':
      return _$none;
    case 'available':
      return _$available;
    case 'allocated':
      return _$allocated;
    case 'completed':
      return _$completed;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<Allocation> _$allocationValues =
    new BuiltSet<Allocation>(const <Allocation>[
  _$none,
  _$available,
  _$allocated,
  _$completed,
]);

Serializer<Allocation> _$allocationSerializer = new _$AllocationSerializer();

class _$AllocationSerializer implements PrimitiveSerializer<Allocation> {
  @override
  final Iterable<Type> types = const <Type>[Allocation];
  @override
  final String wireName = 'Allocation';

  @override
  Object serialize(Serializers serializers, Allocation object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  Allocation deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      Allocation.valueOf(serialized as String);
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
