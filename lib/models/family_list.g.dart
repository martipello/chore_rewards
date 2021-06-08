// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FamilyList> _$familyListSerializer = new _$FamilyListSerializer();

class _$FamilyListSerializer implements StructuredSerializer<FamilyList> {
  @override
  final Iterable<Type> types = const [FamilyList, _$FamilyList];
  @override
  final String wireName = 'FamilyList';

  @override
  Iterable<Object?> serialize(Serializers serializers, FamilyList object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'familyList',
      serializers.serialize(object.familyList,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Family)])),
    ];

    return result;
  }

  @override
  FamilyList deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FamilyListBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'familyList':
          result.familyList.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Family)]))!
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$FamilyList extends FamilyList {
  @override
  final BuiltList<Family> familyList;

  factory _$FamilyList([void Function(FamilyListBuilder)? updates]) =>
      (new FamilyListBuilder()..update(updates)).build();

  _$FamilyList._({required this.familyList}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        familyList, 'FamilyList', 'familyList');
  }

  @override
  FamilyList rebuild(void Function(FamilyListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FamilyListBuilder toBuilder() => new FamilyListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FamilyList && familyList == other.familyList;
  }

  @override
  int get hashCode {
    return $jf($jc(0, familyList.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FamilyList')
          ..add('familyList', familyList))
        .toString();
  }
}

class FamilyListBuilder implements Builder<FamilyList, FamilyListBuilder> {
  _$FamilyList? _$v;

  ListBuilder<Family>? _familyList;
  ListBuilder<Family> get familyList =>
      _$this._familyList ??= new ListBuilder<Family>();
  set familyList(ListBuilder<Family>? familyList) =>
      _$this._familyList = familyList;

  FamilyListBuilder();

  FamilyListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _familyList = $v.familyList.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FamilyList other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FamilyList;
  }

  @override
  void update(void Function(FamilyListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FamilyList build() {
    _$FamilyList _$result;
    try {
      _$result = _$v ?? new _$FamilyList._(familyList: familyList.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'familyList';
        familyList.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'FamilyList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
