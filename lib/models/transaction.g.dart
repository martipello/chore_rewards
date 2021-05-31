// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Transaction> _$transactionSerializer = new _$TransactionSerializer();

class _$TransactionSerializer implements StructuredSerializer<Transaction> {
  @override
  final Iterable<Type> types = const [Transaction, _$Transaction];
  @override
  final String wireName = 'Transaction';

  @override
  Iterable<Object?> serialize(Serializers serializers, Transaction object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.reward;
    if (value != null) {
      result..add('reward')..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.from;
    if (value != null) {
      result..add('from')..add(serializers.serialize(value, specifiedType: const FullType(FamilyMember)));
    }
    value = object.to;
    if (value != null) {
      result..add('to')..add(serializers.serialize(value, specifiedType: const FullType(FamilyMember)));
    }
    value = object.date;
    if (value != null) {
      result..add('date')..add(serializers.serialize(value, specifiedType: const FullType(DateTime)));
    }
    return result;
  }

  @override
  Transaction deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TransactionBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'reward':
          result.reward = serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'from':
          result.from
              .replace(serializers.deserialize(value, specifiedType: const FullType(FamilyMember))! as FamilyMember);
          break;
        case 'to':
          result.to
              .replace(serializers.deserialize(value, specifiedType: const FullType(FamilyMember))! as FamilyMember);
          break;
        case 'date':
          result.date = serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$Transaction extends Transaction {
  @override
  final String? reward;
  @override
  final FamilyMember? from;
  @override
  final FamilyMember? to;
  @override
  final DateTime? date;

  factory _$Transaction([void Function(TransactionBuilder)? updates]) =>
      (new TransactionBuilder()..update(updates)).build();

  _$Transaction._({this.reward, this.from, this.to, this.date}) : super._();

  @override
  Transaction rebuild(void Function(TransactionBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  TransactionBuilder toBuilder() => new TransactionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Transaction && reward == other.reward && from == other.from && to == other.to && date == other.date;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc($jc(0, reward.hashCode), from.hashCode), to.hashCode), date.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Transaction')
          ..add('reward', reward)
          ..add('from', from)
          ..add('to', to)
          ..add('date', date))
        .toString();
  }
}

class TransactionBuilder implements Builder<Transaction, TransactionBuilder> {
  _$Transaction? _$v;

  String? _reward;
  String? get reward => _$this._reward;
  set reward(String? reward) => _$this._reward = reward;

  FamilyMemberBuilder? _from;
  FamilyMemberBuilder get from => _$this._from ??= new FamilyMemberBuilder();
  set from(FamilyMemberBuilder? from) => _$this._from = from;

  FamilyMemberBuilder? _to;
  FamilyMemberBuilder get to => _$this._to ??= new FamilyMemberBuilder();
  set to(FamilyMemberBuilder? to) => _$this._to = to;

  DateTime? _date;
  DateTime? get date => _$this._date;
  set date(DateTime? date) => _$this._date = date;

  TransactionBuilder();

  TransactionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reward = $v.reward;
      _from = $v.from?.toBuilder();
      _to = $v.to?.toBuilder();
      _date = $v.date;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Transaction other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Transaction;
  }

  @override
  void update(void Function(TransactionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Transaction build() {
    _$Transaction _$result;
    try {
      _$result = _$v ?? new _$Transaction._(reward: reward, from: _from?.build(), to: _to?.build(), date: date);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'from';
        _from?.build();
        _$failedField = 'to';
        _to?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('Transaction', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
