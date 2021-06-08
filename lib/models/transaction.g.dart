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
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.title;
    if (value != null) {
      result
        ..add('title')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.reward;
    if (value != null) {
      result
        ..add('reward')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.from;
    if (value != null) {
      result
        ..add('from')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(AllocatedFamilyMember)));
    }
    value = object.to;
    if (value != null) {
      result
        ..add('to')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(AllocatedFamilyMember)));
    }
    value = object.date;
    if (value != null) {
      result
        ..add('date')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.transactionType;
    if (value != null) {
      result
        ..add('transactionType')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(TransactionType)));
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
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'reward':
          result.reward = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'from':
          result.from.replace(serializers.deserialize(value,
                  specifiedType: const FullType(AllocatedFamilyMember))!
              as AllocatedFamilyMember);
          break;
        case 'to':
          result.to.replace(serializers.deserialize(value,
                  specifiedType: const FullType(AllocatedFamilyMember))!
              as AllocatedFamilyMember);
          break;
        case 'date':
          result.date = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'transactionType':
          result.transactionType = serializers.deserialize(value,
                  specifiedType: const FullType(TransactionType))
              as TransactionType;
          break;
      }
    }

    return result.build();
  }
}

class _$Transaction extends Transaction {
  @override
  final String? id;
  @override
  final String? title;
  @override
  final double? reward;
  @override
  final AllocatedFamilyMember? from;
  @override
  final AllocatedFamilyMember? to;
  @override
  final DateTime? date;
  @override
  final TransactionType? transactionType;

  factory _$Transaction([void Function(TransactionBuilder)? updates]) =>
      (new TransactionBuilder()..update(updates)).build();

  _$Transaction._(
      {this.id,
      this.title,
      this.reward,
      this.from,
      this.to,
      this.date,
      this.transactionType})
      : super._();

  @override
  Transaction rebuild(void Function(TransactionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TransactionBuilder toBuilder() => new TransactionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Transaction &&
        id == other.id &&
        title == other.title &&
        reward == other.reward &&
        from == other.from &&
        to == other.to &&
        date == other.date &&
        transactionType == other.transactionType;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, id.hashCode), title.hashCode),
                        reward.hashCode),
                    from.hashCode),
                to.hashCode),
            date.hashCode),
        transactionType.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Transaction')
          ..add('id', id)
          ..add('title', title)
          ..add('reward', reward)
          ..add('from', from)
          ..add('to', to)
          ..add('date', date)
          ..add('transactionType', transactionType))
        .toString();
  }
}

class TransactionBuilder implements Builder<Transaction, TransactionBuilder> {
  _$Transaction? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  double? _reward;
  double? get reward => _$this._reward;
  set reward(double? reward) => _$this._reward = reward;

  AllocatedFamilyMemberBuilder? _from;
  AllocatedFamilyMemberBuilder get from =>
      _$this._from ??= new AllocatedFamilyMemberBuilder();
  set from(AllocatedFamilyMemberBuilder? from) => _$this._from = from;

  AllocatedFamilyMemberBuilder? _to;
  AllocatedFamilyMemberBuilder get to =>
      _$this._to ??= new AllocatedFamilyMemberBuilder();
  set to(AllocatedFamilyMemberBuilder? to) => _$this._to = to;

  DateTime? _date;
  DateTime? get date => _$this._date;
  set date(DateTime? date) => _$this._date = date;

  TransactionType? _transactionType;
  TransactionType? get transactionType => _$this._transactionType;
  set transactionType(TransactionType? transactionType) =>
      _$this._transactionType = transactionType;

  TransactionBuilder();

  TransactionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _reward = $v.reward;
      _from = $v.from?.toBuilder();
      _to = $v.to?.toBuilder();
      _date = $v.date;
      _transactionType = $v.transactionType;
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
      _$result = _$v ??
          new _$Transaction._(
              id: id,
              title: title,
              reward: reward,
              from: _from?.build(),
              to: _to?.build(),
              date: date,
              transactionType: transactionType);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'from';
        _from?.build();
        _$failedField = 'to';
        _to?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Transaction', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
