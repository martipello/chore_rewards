// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piggy_bank.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PiggyBank> _$piggyBankSerializer = new _$PiggyBankSerializer();

class _$PiggyBankSerializer implements StructuredSerializer<PiggyBank> {
  @override
  final Iterable<Type> types = const [PiggyBank, _$PiggyBank];
  @override
  final String wireName = 'PiggyBank';

  @override
  Iterable<Object?> serialize(Serializers serializers, PiggyBank object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'transactions',
      serializers.serialize(object.transactions,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Transaction)])),
    ];
    Object? value;
    value = object.balance;
    if (value != null) {
      result
        ..add('balance')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    return result;
  }

  @override
  PiggyBank deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PiggyBankBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'balance':
          result.balance = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'transactions':
          result.transactions.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Transaction)]))!
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$PiggyBank extends PiggyBank {
  @override
  final double? balance;
  @override
  final BuiltList<Transaction> transactions;

  factory _$PiggyBank([void Function(PiggyBankBuilder)? updates]) =>
      (new PiggyBankBuilder()..update(updates)).build();

  _$PiggyBank._({this.balance, required this.transactions}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        transactions, 'PiggyBank', 'transactions');
  }

  @override
  PiggyBank rebuild(void Function(PiggyBankBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PiggyBankBuilder toBuilder() => new PiggyBankBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PiggyBank &&
        balance == other.balance &&
        transactions == other.transactions;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, balance.hashCode), transactions.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PiggyBank')
          ..add('balance', balance)
          ..add('transactions', transactions))
        .toString();
  }
}

class PiggyBankBuilder implements Builder<PiggyBank, PiggyBankBuilder> {
  _$PiggyBank? _$v;

  double? _balance;
  double? get balance => _$this._balance;
  set balance(double? balance) => _$this._balance = balance;

  ListBuilder<Transaction>? _transactions;
  ListBuilder<Transaction> get transactions =>
      _$this._transactions ??= new ListBuilder<Transaction>();
  set transactions(ListBuilder<Transaction>? transactions) =>
      _$this._transactions = transactions;

  PiggyBankBuilder();

  PiggyBankBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _balance = $v.balance;
      _transactions = $v.transactions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PiggyBank other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PiggyBank;
  }

  @override
  void update(void Function(PiggyBankBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PiggyBank build() {
    _$PiggyBank _$result;
    try {
      _$result = _$v ??
          new _$PiggyBank._(
              balance: balance, transactions: transactions.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'transactions';
        transactions.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'PiggyBank', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
