// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TransactionType _$addition = const TransactionType._('addition');
const TransactionType _$subtraction = const TransactionType._('subtraction');

TransactionType _$transactionTypeValueOf(String name) {
  switch (name) {
    case 'addition':
      return _$addition;
    case 'subtraction':
      return _$subtraction;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<TransactionType> _$transactionTypeValues =
    new BuiltSet<TransactionType>(const <TransactionType>[
  _$addition,
  _$subtraction,
]);

Serializer<TransactionType> _$transactionTypeSerializer =
    new _$TransactionTypeSerializer();

class _$TransactionTypeSerializer
    implements PrimitiveSerializer<TransactionType> {
  @override
  final Iterable<Type> types = const <Type>[TransactionType];
  @override
  final String wireName = 'TransactionType';

  @override
  Object serialize(Serializers serializers, TransactionType object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  TransactionType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TransactionType.valueOf(serialized as String);
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
