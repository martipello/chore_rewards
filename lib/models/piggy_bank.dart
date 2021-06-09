import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers/serializers.dart';

part 'piggy_bank.g.dart';

abstract class PiggyBank implements Built<PiggyBank, PiggyBankBuilder> {
  factory PiggyBank([void Function(PiggyBankBuilder) updates]) = _$PiggyBank;

  PiggyBank._();

  double? get balance;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(PiggyBank.serializer, this) as Map<String, dynamic>;
  }

  static PiggyBank? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(PiggyBank.serializer, json);
  }

  static Serializer<PiggyBank> get serializer => _$piggyBankSerializer;
}
