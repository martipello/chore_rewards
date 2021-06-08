import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:chore_rewards/models/allocated_family_member.dart';
import 'package:chore_rewards/models/transaction_type.dart';

import '../serializers/serializers.dart';
import 'family_member.dart';

part 'transaction.g.dart';

abstract class Transaction implements Built<Transaction, TransactionBuilder> {
  factory Transaction([void Function(TransactionBuilder) updates]) = _$Transaction;

  Transaction._();

  String? get id;

  String? get title;

  double? get reward;

  AllocatedFamilyMember? get from;

  AllocatedFamilyMember? get to;

  DateTime? get date;

  TransactionType? get transactionType;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Transaction.serializer, this) as Map<String, dynamic>;
  }

  static Transaction? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Transaction.serializer, json);
  }

  static Serializer<Transaction> get serializer => _$transactionSerializer;
}
