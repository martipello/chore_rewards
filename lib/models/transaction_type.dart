import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers/serializers.dart';

part 'transaction_type.g.dart';

class TransactionType extends EnumClass {
  const TransactionType._(String name) : super(name);

  static const TransactionType addition = _$addition;
  static const TransactionType subtraction = _$subtraction;


  static BuiltSet<TransactionType> get values => _$transactionTypeValues;

  static TransactionType valueOf(String name) => _$transactionTypeValueOf(name);

  String serialize() {
    return serializers.serializeWith(TransactionType.serializer, this) as String;
  }

  static TransactionType? deserialize(String string) {
    return serializers.deserializeWith(TransactionType.serializer, string);
  }

  static Serializer<TransactionType> get serializer => _$transactionTypeSerializer;
}
