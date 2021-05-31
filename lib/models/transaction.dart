import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers/serializers.dart';
import 'family_member.dart';

part 'transaction.g.dart';

abstract class Transaction implements Built<Transaction, TransactionBuilder> {
  factory Transaction([void Function(TransactionBuilder) updates]) = _$Transaction;

  Transaction._();

  String? get reward;

  FamilyMember? get from;

  FamilyMember? get to;

  DateTime? get date;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Transaction.serializer, this) as Map<String, dynamic>;
  }

  static Transaction? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Transaction.serializer, json);
  }

  static Serializer<Transaction> get serializer => _$transactionSerializer;
}
